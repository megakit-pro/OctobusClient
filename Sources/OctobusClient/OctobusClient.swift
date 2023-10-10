import Foundation
import Starscream

public class OctobusClient: OctobusClientProtocol {
    public weak var delegate: OctobusClientDelegate?
    
    private var socket: WebSocket?
    private let logPrefix = "[OctobusClient]"
    
    public init() {
        
    }
    
    func log(_ message: String) {
        print("\(logPrefix) \(message)")
    }
    
    public func connect(to url: String?, with token: String?) {
        guard let token = token, let url = url, let socketURL = URL(string: url) else {
            log("Invalid URL")
            return
        }
        
        log("Connecting to: \(socketURL)")
        
        var request = URLRequest(url: socketURL)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        socket = WebSocket(request: request)
        socket?.delegate = self
        
        socket?.connect()
    }
    
    public func disconnect() {
        socket?.disconnect()
    }
    
    public func send(message: Message) {
        if let messageData = message.jsonString().data(using: .utf8),
           let compressedData = messageData.gzipCompress() {
            socket?.write(data: compressedData)
        }
    }
}

extension OctobusClient: WebSocketDelegate {
    public func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        func notifyDelegateConnectionStatus(_ status: Bool) {
            delegate?.setConnected(status)
        }
        
        switch event {
            case .connected(let headers):
                log("websocket is connected: \(headers)")
                notifyDelegateConnectionStatus(true)
            case .disconnected(let reason, let code):
                log("websocket is disconnected: \(reason) with code: \(code)")
                notifyDelegateConnectionStatus(false)
            case  .cancelled:
                log("websocket is cancelled")
                notifyDelegateConnectionStatus(false)
            case .text(let string):
                log("Received text: \(string)")
                if let data = string.data(using: .utf8) {
                    delegate?.handleIcommingMessage(data: data)
                }
            case .binary(let data):
                log("Received binary data: \(data.count) bytes")
                if let decompressedData = data.gzipDecompress() {
                    delegate?.handleIcommingMessage(data: decompressedData)
                } else {
                    log("Failed to decompress gzip data")
                }
                break
            case .error(let error):
                log("Error: \(error?.localizedDescription ?? "Unknown error")")
                if let error = error {
                    delegate?.setError(error)
                    notifyDelegateConnectionStatus(false)
                }
            case .peerClosed:
                log("Peer Closed")
            case .pong(_):
                break
            case .ping(_):
                break
            case .viabilityChanged(let viable):
                notifyDelegateConnectionStatus(viable)
                viable ? log("network is viable") : log("network is not viable")
                
            case .reconnectSuggested(_):
                log("reconnectSuggested")
        }
    }
}
