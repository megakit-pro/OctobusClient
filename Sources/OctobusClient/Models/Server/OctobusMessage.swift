//
//  ServerPayload.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 21.03.2023.
//
import Foundation

/// `OctobusMessage` is a structure that represents an Octobus message.
/// It conforms to the `Codable` and `Identifiable` protocols for easy encoding, decoding and identification.
public struct OctobusMessage: Codable, Identifiable {
    /// An optional `ServerChat` object representing the chat associated with the message.
    public let chat: ServerChat?
    /// An optional `Int` representing the ID of the message.
    public let id: Int?
    /// An optional `ServerUpdateMessage` object representing the update message associated with the Octobus message.
    public let message: ServerUpdateMessage?
    /// An optional `ServerMessageType` object representing the type of the message.
    public let messageType: ServerMessageType?
    /// An optional `ServerUser` object representing the user associated with the message.
    public let user: ServerUser?
    /// An optional `String` representing the client type.
    public let clientType: String?
    /// An optional `Int` representing the user ID.
    public let userId: Int?
    /// An optional `Int` representing the connection ID.
    public let connectionId: Int?
    /// An optional `String` representing the error associated with the message.
    public let error: String?
    /// An optional `String` representing the action associated with the message.
    public let action: String?

    /// An enumeration that represents the coding keys for the `OctobusMessage` structure.
    enum CodingKeys: String, CodingKey {
        case chat, id, message
        case messageType = "message_type"
        case user
        case clientType = "client_type"
        case userId = "user_id"
        case connectionId = "connection_id"
        case error
        case action
    }
}
