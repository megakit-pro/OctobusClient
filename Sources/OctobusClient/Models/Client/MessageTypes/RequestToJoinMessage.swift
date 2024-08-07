//
// Created by Anton Stremovskyy on 22.03.2023.
//

import Foundation


/// `RequestToJoinMessage` is a type alias for the `Message` type.
public typealias RequestToJoinMessage = Message

/// Creates a `RequestToJoinMessage` with the given chat ID.
///
/// This function creates a `RequestToJoinMessage` with a payload that contains the given chat ID.
/// The message type of the created `RequestToJoinMessage` is `.joinRequest`.
///
/// - Parameter chatID: The ID of the chat to include in the payload of the `RequestToJoinMessage`.
/// - Returns: A `RequestToJoinMessage` with the given chat ID in its payload.
public func createRequestToJoinMessage(chatID: Int) -> RequestToJoinMessage {
    let payload = Payload(chatID: chatID)

    return RequestToJoinMessage(messageType: .joinRequest, payload: payload)
}

/// Creates a `RequestToJoinMessage` with the given request UUID.
///
/// This function creates a `RequestToJoinMessage` with a payload that contains the given request UUID.
/// The message type of the created `RequestToJoinMessage` is `.joinRequest`.
///
/// - Parameter requestUUID: The UUID of the request to include in the payload of the `RequestToJoinMessage`.
/// - Returns: A `RequestToJoinMessage` with the given request UUID in its payload.
public func createRequestToJoinMessage(requestUUID: String) -> RequestToJoinMessage {
    let payload = Payload(requestUuid: requestUUID)

    return RequestToJoinMessage(messageType: .joinRequest, payload: payload)
}
