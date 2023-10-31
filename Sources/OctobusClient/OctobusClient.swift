import Foundation
import Starscream

public class OctobusClient: OctobusClientProtocol {

    // MARK: - Properties
    public weak var delegate: OctobusClientDelegate?

    private var socket: WebSocket?
    private var logPrefix = "[OctobusClient]"
    private let connectionTimeout: TimeInterval = 3.0
    private let circuitOpenDuration: TimeInterval = 60.0
    private let budgetReplenishInterval: TimeInterval = 10.0
    private let maxConsecutiveFailures = 3
    private var isDebug = false

    private struct ConnectionDetails {
        let url: String
        let token: String
    }

    private var connectionDetails: ConnectionDetails?

    private var connectionTimeoutTask: DispatchWorkItem?
    private var retryBudget = 100
    private let budgetCost = 2
    private let budgetReplenishRate = 1
    private var consecutiveFailures = 0

    private enum CircuitState {
        case closed
        case open(Date)
        case halfOpen
    }

    private var circuitState: CircuitState = .closed

    private let queue = DispatchQueue(label: "com.octobus.retryQueue")
    private let wsQueue = DispatchQueue(label: "com.octobus.wsQueue", qos: .userInitiated)

    // MARK: - Initializer
    public init(debug: Bool = false) {
        if debug {
            logPrefix = "[OctobusClient DEBUG]"
            isDebug = true
        }
    }

    // MARK: - Helper Functions
    private func log(_ message: String) {
        print("\(logPrefix) \(message)")
    }

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

    private func scheduleConnectionTimeoutTask() {
        connectionTimeoutTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            self?.connectionLost()
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + connectionTimeout, execute: task)
        connectionTimeoutTask = task
    }

    private func setUpSocket(with url: URL, token: String) {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 5

        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.callbackQueue = wsQueue
    }

    public func disconnect() {
        socket?.disconnect()
        consecutiveFailures = 0
    }

    public func send(message: Message) {
        if let messageData = message.jsonString().data(using: .utf8),
           let compressedData = messageData.gzipCompress() {
            socket?.write(data: compressedData)
        }
    }

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

    private func adjustRetryBudget() {
        retryBudget = max(0, retryBudget - budgetCost)

        queue.asyncAfter(deadline: .now() + budgetReplenishInterval) { [weak self] in
            self?.retryBudget += self?.budgetReplenishRate ?? 0
        }
    }

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

    private func connectionSucceeded(_ headers: [String: String]) {
        log("websocket is connected: \(headers)")
        delegate?.setConnected(true)
        connectionTimeoutTask?.cancel()
        consecutiveFailures = 0
        circuitState = .closed
    }

    private func connectionLost() {
        delegate?.setConnected(false)
        circuitState = .halfOpen
        attemptReconnection()
    }

    private func processReceivedData(_ data: Data) {
        if let message = try? JSONDecoder().decode(ServerMessage<OctobusMessage>.self, from: data) {
            delegate?.onOctobusMessage(serverMessage: message)
        } else {
            do {
                let arrayMessage = try JSONDecoder().decode(ServerMessage<[OctobusMessage]>.self, from: data)
                delegate?.onOctobusMessages(serverMessage: arrayMessage)
            } catch let arrayError as DecodingError {
                log("Error decoding array of OctobusMessages: \(arrayError.localizedDescription). Detailed error: \(detailedErrorDescription(error: arrayError))")
            } catch {
                log("Unexpected error decoding array of OctobusMessages: \(error)")
            }
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
        delegate?.setConnected(viable)
        log(viable ? "network is viable" : "network is not viable")
    }

    // MARK: - Handle Connection Events
    private func handleConnectionEvents(_ event: WebSocketEvent) {
        switch event {
        case .connected(let headers):
            connectionSucceeded(headers)
        case .disconnected(_, _), .peerClosed, .reconnectSuggested(_):
            connectionLost()
        case .cancelled:
            delegate?.setConnected(false)
            log("websocket is cancelled")
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
        case .pong(_), .ping(_):
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
