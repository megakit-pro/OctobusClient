//
//  ServerPayload.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 21.03.2023.
//

import Foundation


// MARK: - Payload
public struct OctobusMessage: Codable, Identifiable {
    public let chat: ServerChat?
    public let id: Int?
    public let message: ServerUpdateMessage?
    public let messageType: ServerMessageType?
    public let user: ServerUser?
    public let clientType: String?
    public let userId: Int?
    public let connectionId: Int?
    public let error: String?
    public let action: String?

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
