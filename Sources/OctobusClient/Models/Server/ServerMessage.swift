//
//  ServerMessage.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 20.03.2023.
//

import Foundation

/// `PayloadType` is an enumeration that represents the type of payload in a server message.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public enum PayloadType: String, Codable {
    case updates
    case broadcast
    case connect
    case disconnect
    case error
}

/// `ServerMessage` is a generic structure that represents a server message.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public struct ServerMessage<T: Codable>: Codable {
    /// A generic `T` representing the payload of the server message.
    public let payload: T
    /// A `PayloadType` representing the type of the payload.
    public let type: PayloadType
}

/// An extension of `ServerMessage` that provides additional functionality.
extension ServerMessage {
    /// Initializes a `ServerMessage` from a `Data` object.
    ///
    /// - Parameter data: The `Data` object to decode the `ServerMessage` from.
    public init(data: Data) throws {
        try self = JSONDecoder().decode(ServerMessage<T>.self, from: data)
    }

    /// Determines whether the server message needs to be shown.
    ///
    /// - Returns: A `Bool` indicating whether the server message needs to be shown.
    public func isNeedToShow() -> Bool {
        type == .updates
    }
}
