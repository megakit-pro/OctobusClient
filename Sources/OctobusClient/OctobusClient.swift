import Foundation
import Starscream

/// OctobusClient class implementing the OctobusClientProtocol
public class OctobusClient: OctobusClientProtocol {

    // MARK: - Properties

    /// Delegate to handle events
    public weak var delegate: OctobusClientDelegate?

    /// WebSocket instance for communication
    private var socket: WebSocket?
    /// Prefix for log messages
    private var logPrefix = "[OctobusClient]"
    /// Timeout for connection attempts
    private let connectionTimeout: TimeInterval = 3.0
    /// Duration for which the circuit remains open
    private let circuitOpenDuration: TimeInterval = 60.0
    /// Interval for replenishing the retry budget
    private let budgetReplenishInterval: TimeInterval = 10.0
    /// Maximum number of consecutive failures before opening the circuit
    private let maxConsecutiveFailures = 3
    /// Debug flag
    private var isDebug = false

    /// Struct to hold connection details
    private struct ConnectionDetails {
        let url: String
        let token: String
    }

    /// Connection details instance
    private var connectionDetails: ConnectionDetails?

    /// Task for connection timeout
    private var connectionTimeoutTask: DispatchWorkItem?
    /// Retry budget for connection attempts
    private var retryBudget = 100
    /// Cost of a retry attempt
    private let budgetCost = 2
    /// Rate of replenishing the retry budget
    private let budgetReplenishRate = 1
    /// Number of consecutive failures
    private var consecutiveFailures = 0

    /// Enum to represent the state of the circuit
    private enum CircuitState {
        case closed
        case open(Date)
        case halfOpen
    }

    /// Current state of the circuit
    private var circuitState: CircuitState = .closed

    /// Queues for retry and WebSocket operations
    private let queue = DispatchQueue(label: "com.octobus.retryQueue")
    private let wsQueue = DispatchQueue(label: "com.octobus.wsQueue", qos: .userInitiated)

    // MARK: - Initializer

    /// Initializer with optional debug flag
    public init(debug: Bool = false) {
        if debug {
            logPrefix = "[OctobusClient DEBUG]"
            isDebug = true
        }
    }

    // MARK: - Helper Functions

    /// Function to log messages with the log prefix
    private func log(_ message: String) {
        print("\(logPrefix) \(message)")
    }

    /// Function to connect to the server
    public func connect(to url: String?, with token: String?) {
        guard let url = url, let token = token, let socketURL = URL(string: url) else {
            log("Invalid URL")
            return
        }

        log("Connecting to: \(socketURL)")
        connectionDetails = ConnectionDetails(url: url, token: token)

        setUpSocket(with: socketURL, token: token)
        scheduleConnectionTimeoutTask()
        socket?.connect()
    }

    /// Function to schedule a connection timeout task
    private func scheduleConnectionTimeoutTask() {
        connectionTimeoutTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            self?.connectionLost()
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + connectionTimeout, execute: task)
        connectionTimeoutTask = task
    }

    /// Function to set up the WebSocket with the given URL and token
    private func setUpSocket(with url: URL, token: String) {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 5

        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.callbackQueue = wsQueue
    }

    /// Function to disconnect from the server
    public func disconnect() {
        socket?.disconnect()
        consecutiveFailures = 0
    }

    /// Function to send a message to the server
    public func send(message: Message) {
        if let messageData = message.jsonString().data(using: .utf8),
           let compressedData = messageData.gzipCompress() {
            socket?.write(data: compressedData)
        }
    }

    /// Function to check if a connection retry can be attempted
    private func canRetryConnection() -> Bool {
        switch circuitState {
        case .closed:
            return retryBudget > 0
        case .open(let openSince):
            if Date().timeIntervalSince(openSince) >= circuitOpenDuration {
                circuitState = .halfOpen
                return true
            }
            return false
        case .halfOpen:
            return retryBudget > 0
        }
    }

    /// Function to adjust the retry budget
    private func adjustRetryBudget() {
        retryBudget = max(0, retryBudget - budgetCost)

        queue.asyncAfter(deadline: .now() + budgetReplenishInterval) { [weak self] in
            self?.retryBudget += self?.budgetReplenishRate ?? 0
        }
    }

    /// Function to attempt reconnection
    private func attemptReconnection() {
        guard canRetryConnection() else {
            log("Cannot retry due to exhausted retry budget or open circuit.")
            return
        }

        let baseDelay = 2.0
        let maxJitter = 1.0
        let jitter = Double.random(in: 0..<maxJitter)
        let delay = baseDelay * pow(2.0, Double(consecutiveFailures)) + jitter

        queue.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let details = self?.connectionDetails else {
                return
            }
            self?.log("Attempting to reconnect. Retry #\(self?.consecutiveFailures ?? 0)")
            self?.connect(to: details.url, with: details.token)
        }

        consecutiveFailures += 1
        adjustRetryBudget()

        if consecutiveFailures >= maxConsecutiveFailures {
            circuitState = .open(Date())
        }
    }

    /// Function to handle successful connection
    private func connectionSucceeded(_ headers: [String: String]) {
        log("websocket is connected: \(headers)")
        delegate?.setConnected(true)
        connectionTimeoutTask?.cancel()
        consecutiveFailures = 0
        circuitState = .closed
    }

    /// Function to handle connection loss
    private func connectionLost() {
        delegate?.setConnected(false)
        circuitState = .halfOpen
        attemptReconnection()
    }

    /// Function to process received data
    private func processReceivedData(_ data: Data) {
        if let message = try? JSONDecoder().decode(ServerMessage<OctobusMessage>.self, from: data) {
            /// Returns a single `OctobusMessage` to a delegate
            delegate?.onOctobusMessage(serverMessage: message)
        } else if let arrayMessage = try? JSONDecoder().decode(ServerMessage<[OctobusMessage]>.self, from: data) {
            /// Returns an array of `OctobusMessage` to a delegate
            delegate?.onOctobusMessages(serverMessage: arrayMessage)
        } else {
            /// Data is not representable in any handled type
            ///
            /// Returns plain `Data` to a delegate
            delegate?.onOctobusData(data)
            log("Data can't be represented in any handled type")
        }
    }

    private func detailedErrorDescription(error: DecodingError) -> String {
        switch error {
        case .typeMismatch(_, let context):
            return "Type mismatch for key: \(context.codingPath.description). Expected type \(context.debugDescription)."
        case .valueNotFound(_, let context):
            return "Value not found for key: \(context.codingPath.description). \(context.debugDescription)"
        case .keyNotFound(_, let context):
            return "Key not found: \(context.codingPath.description). \(context.debugDescription)"
        case .dataCorrupted(let context):
            return "Data corrupted at key: \(context.codingPath.description). \(context.debugDescription)"
        @unknown default:
            return "Unknown decoding error."
        }
    }


    private func handleReceivedText(_ string: String) {
        log("Received text: \(string)")
        if let data = string.data(using: .utf8) {
            if isDebug {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    log("Text data: \(jsonObject)")
                } catch {
                    log("Failed to parse data: \(error)")
                }
            }

            processReceivedData(data)
        }
    }

    private func handleReceivedBinaryData(_ data: Data) {
        log("Received binary data: \(data.count) bytes")
        if let decompressedData = data.gzipDecompress() {
            log("Decompressed data: \(decompressedData.count) bytes")
            if isDebug {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: decompressedData, options: [])
                    log("Decompressed data: \(jsonObject)")
                } catch {
                    log("Failed to parse data: \(error)")
                }
            }
            processReceivedData(decompressedData)
        } else {
            log("Failed to decompress gzip data")
        }
    }

    private func handleError(_ error: Error?) {
        log("Error: \(error?.localizedDescription ?? "Unknown error")")
        if let error = error {
            delegate?.setError(error)
            delegate?.setConnected(false)
        }
    }

    private func handleNetworkViability(_ viable: Bool) {
        log(viable ? "network is viable" : "network is not viable")
    }

    // MARK: - Handle Connection Events
    private func handleConnectionEvents(_ event: WebSocketEvent) {
        switch event {
            case .connected(let headers):
                connectionSucceeded(headers)
            case .disconnected(_, _), .reconnectSuggested(_), .cancelled:
                connectionLost()
            case .text(let string):
                handleReceivedText(string)
            case .binary(let data):
                handleReceivedBinaryData(data)
            case .error(let error):
                if let upgradeError = error as? HTTPUpgradeError {
                    switch upgradeError {
                        case .notAnUpgrade(let statusCode, _):
                            if statusCode == 401 {
                                connectionTimeoutTask?.cancel()
                                delegate?.authenticationFailed()
                                return
                            }
                            
                        default:
                            handleError(error)
                    }
                } else {
                    handleError(error)
                }
            case .pong(_), .ping(_), .peerClosed:
                break
            case .viabilityChanged(let viable):
                handleNetworkViability(viable)
        }
    }
}

// MARK: - WebSocketDelegate
extension OctobusClient: WebSocketDelegate {
    public func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        handleConnectionEvents(event)
    }
}
