    //
    //  Message.swift
    //  chatter
    //
    //  Created by Anton Stremovskyy on 20.03.2023.
    //

import Foundation

    // MARK: - MessageType
public enum MessageType: String, Codable {
    case text = "text_message"
    case image = "image_message"
    case location = "location_message"
    case getUpdates = "get_updates"
    case commitUpdates = "commit_updates"
    case joinRequest = "join_request"
    case leaveRequest = "leave_request"
    case typing = "typing"
    case readConfirm = "read_confirm"
}

    // MARK: - Message
public class Message: Codable, Identifiable {
    public let id: UUID = UUID()
    let messageType: MessageType
    let payload: Payload
    
    enum CodingKeys: String, CodingKey {
        case messageType = "message_type"
        case payload
    }
    
    init(messageType: MessageType, payload: Payload) {
        self.messageType = messageType
        self.payload = payload
    }
}

    // MARK: - Payload
struct Payload: Codable {
    let chatID: Int?
    let text: String?
    let imageUrl: String?
    let latitude: Double?
    let longitude: Double?
    let limit: Int?
    let offset: Int?
    let latestUpdateId: Int?
    let isTyping: Bool?
    let messageId: Int?
    let requestUuid: String?
    
    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case text
        case imageUrl = "image_url"
        case latitude
        case longitude
        case limit
        case offset
        case latestUpdateId = "latest_update_id"
        case isTyping = "is_typing"
        case messageId = "message_id"
        case requestUuid = "request_uuid"
    }
    
    init(chatID: Int? = nil,
         text: String? = nil,
         imageUrl: String? = nil,
         latitude: Double? = nil,
         longitude: Double? = nil,
         limit: Int? = nil,
         offset: Int? = nil,
         latestUpdateId: Int? = nil,
         isTyping: Bool? = nil,
         messageId: Int? = nil,
         requestUuid: String? = nil) {
        self.chatID = chatID
        self.text = text
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.longitude = longitude
        self.limit = limit
        self.offset = offset
        self.latestUpdateId = latestUpdateId
        self.isTyping = isTyping
        self.messageId = messageId
        self.requestUuid = requestUuid
    }
}

extension Message {
    func jsonString() -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let jsonData = try? encoder.encode(self), let jsonString = String(data: jsonData, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }
}
