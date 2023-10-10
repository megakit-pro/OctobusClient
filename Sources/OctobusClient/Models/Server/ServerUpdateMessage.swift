//
//  ServerUpdateMessage.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 21.03.2023.
//

import Foundation

public struct ServerUpdateMessage: Codable {
    public let createdAt, id, readAt: Int?
    public let requestStatus, chatAction, text, imageUrl: String?
    public let relatedMessageID: Int?
    public let isHidden: Bool?
    public let payload: MessagePayload?

    public enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id
        case requestStatus = "request_status"
        case chatAction = "chat_action"
        case text
        case imageUrl = "image_url"
        case relatedMessageID = "related_message_id"
        case readAt = "read_at"
        case isHidden = "is_hidden"
        case payload = "payload"
    }
}

public enum ServerMessageType: String, Codable {
    case chatStatusUpdated = "chat_status_updated"
    case requestStatusUpdated = "request_status_updated"
    case text = "text"
    case location = "location"
    case image = "image"
    case requestUpdate = "request_update"
}

