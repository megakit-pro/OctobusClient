//
//  ServerUpdateMessage.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 21.03.2023.
//
import Foundation
import CoreLocation

/// `ServerUpdateMessage` represents a message received from the server with a specific type and payload.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public struct ServerUpdateMessage: Codable {
    /// The creation time of the message as an `Int` (optional).
    public let createdAt: Int?
    /// The ID of the message as an `Int` (optional).
    public let id: Int?
    /// The read time of the message as an `Int` (optional).
    public let readAt: Int?
    /// The request status of the message as a `String` (optional).
    public let requestStatus: String?
    /// The chat action of the message as a `String` (optional).
    public let chatAction: String?
    /// The text of the message as a `String` (optional).
    public let text: String?
    /// The image URL of the message as a `String` (optional).
    public let imageUrl: String?
    /// The related message ID as an `Int` (optional).
    public let relatedMessageID: Int?
    /// A `Bool` indicating whether the message is hidden (optional).
    public let isHidden: Bool?
    /// A `Bool` indicating whether the message is pinned (optional).
    public let isPinned: Bool?
    /// The payload of the message as a `MessagePayload` (optional).
    public let payload: MessagePayload?
    /// The location of the message as a `String` (optional).
    public let location: String?

    /// An enumeration that represents the coding keys for the `ServerUpdateMessage` structure.
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
        case payload
        case location
        case isPinned = "is_pinned"
    }
}

/// `ServerMessageType` is an enumeration that represents different types of server messages.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public enum ServerMessageType: String, Codable {
    case chatStatusUpdated = "chat_status_updated"
    case requestStatusUpdated = "request_status_updated"
    case text
    case location
    case image
    case requestUpdate = "request_update"
    case chatCreate = "chat_create"
    case chatDismiss = "chat_dismiss"
    case chatUpdate = "chat_update"
    case messageAck = "chat_status_ack"
    case broadcast
}

extension ServerUpdateMessage {
    /// Converts the location string to a `CLLocationCoordinate2D` object if possible.
    /// - Returns: A `CLLocationCoordinate2D` if the location string is valid, otherwise `nil`.
    public func coordinate() -> CLLocationCoordinate2D? {
        guard let location = location,
              let (lat, lon) = parseCoordinate(from: location) else {
            return nil
        }

        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    /// Parses a coordinate string into latitude and longitude.
    /// - Parameter location: A string representing the location in "latitude,longitude" format.
    /// - Returns: A tuple containing latitude and longitude as `Double`, or `nil` if parsing fails.
    private func parseCoordinate(from location: String) -> (Double, Double)? {
        let components = location.components(separatedBy: ",")
        guard components.count == 2,
              let lat = Double(components[0]),
              let lon = Double(components[1]) else {
            return nil
        }

        return (lat, lon)
    }
}
