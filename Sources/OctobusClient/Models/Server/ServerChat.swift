//
//  ServerChat.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 21.03.2023.
//

import Foundation

/// `ServerChat` is a structure that represents a server chat.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public struct ServerChat: Codable {
    /// An `Int` representing the ID of the chat.
    public let id: Int
    /// A `String` representing the request UUID of the chat.
    public let requestUUID: String
    /// An optional `Bool` indicating whether the chat is sealed.
    public let isSealed: Bool?

    /// An enumeration that represents the coding keys for the `ServerChat` structure.
    enum CodingKeys: String, CodingKey {
        case id
        case requestUUID = "request_uuid"
        case isSealed = "is_sealed"
    }
}
