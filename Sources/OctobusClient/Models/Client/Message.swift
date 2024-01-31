import Foundation

// MARK: - MessageType

/// Represents the type of a message in a communication system.
public enum MessageType: String, Codable {
    case text = "text_message" // Represents a text message.
    case image = "image_message" // Represents an image message.
    case locationMessage = "location_message" // Represents a location message.
    case getUpdates = "get_updates" // Represents a request to get updates.
    case commitUpdates = "commit_updates" // Represents a request to commit updates.
    case joinRequest = "join_request" // Represents a join request.
    case leaveRequest = "leave_request" // Represents a leave request.
    case typing = "typing" // Represents a typing status update.
    case readConfirm = "read_confirm" // Represents a read confirmation.
    case location = "location" // Represents a location update.
    case getChatUpdates = "get_chat_updates" // Represents a request to get chat updates.
    case reportToMessage = "report_to_message" // Represents a report to message.
    case commandMessage = "command" // Represents a command message.
    case userAction = "user_action" // Represents a user action.
}

// MARK: - Message

/// Represents a message with a specific type and payload.
public class Message: Codable, Identifiable {
    public let id: UUID // The unique identifier of the message.
    let messageType: MessageType // The type of the message.
    let payload: Payload // The payload of the message.

    enum CodingKeys: String, CodingKey {
        case messageType = "message_type" // The coding key for the message type.
        case payload // The coding key for the payload.
        case id // The coding key for the id.
    }

    /// Initializes a new message with the given type and payload.
    /// - Parameters:
    ///   - messageType: The type of the message.
    ///   - payload: The payload of the message.
    init(messageType: MessageType, payload: Payload) {
        id = UUID()
        self.messageType = messageType
        self.payload = payload
    }
}

// MARK: - Payload

/// Represents the payload of a message, containing various optional fields.
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
    let chatUUID: String?
    let userID: Int?
    let reportType: ReportType?
    let command: String?
    let params: String?
    let action: UserActionType?

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case text
        case imageUrl = "image_url"
        case latitude = "lat"
        case longitude = "lon"
        case limit
        case offset
        case latestUpdateId = "latest_update_id"
        case isTyping = "is_typing"
        case messageId = "message_id"
        case requestUuid = "request_uuid"
        case chatUUID = "chat_uuid"
        case reportType = "report_type"
        case command
        case params
        case action
        case userID = "user_id"
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
         requestUuid: String? = nil,
         chatUUID: String? = nil,
         reportType: ReportType? = nil,
         command: String? = nil,
         params: String? = nil,
         action: UserActionType? = nil,
         userID: Int? = nil) {
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
        self.chatUUID = chatUUID
        self.reportType = reportType
        self.command = command
        self.params = params
        self.action = action
        self.userID = userID
    }
}

// MARK: - Message Extension

extension Message {
    /// Converts the message object to a JSON string.
    /// - Returns: A JSON string representation of the message or an empty string if encoding fails.
    func jsonString() -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let jsonData = try? encoder.encode(self), let jsonString = String(data: jsonData, encoding: .utf8) else {
            return ""
        }

        return jsonString
    }
}
