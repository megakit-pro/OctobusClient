//
//  OctobusClientProtocol.swift
//
//
//  Created by Anton Stremovskyy on 10.10.2023.
//

import Foundation

/// `OctobusClientProtocol` is a protocol that defines the basic operations for an Octobus client.
public protocol OctobusClientProtocol {

    /// Connects the client to the specified URL using the provided token.
    ///
    /// - Parameters:
    ///   - url: The URL to connect to. This should be a valid WebSocket URL.
    ///   - token: The token to use for authentication.
    func connect(to url: String?, with token: String?)

    /// Disconnects the client from the server.
    func disconnect()

    /// Sends a message to the server.
    ///
    /// - Parameter message: The message to send. This should be an instance of the `Message` class.
    func send(message: Message)
}
