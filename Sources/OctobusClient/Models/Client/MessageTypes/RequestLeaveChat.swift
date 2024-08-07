//
//  RequestLeaveChat.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 23.03.2023.
//

import Foundation

/// `RequestToLeaveMessage` is a type alias for the `Message` type.
public typealias RequestToLeaveMessage = Message

/// Creates a `RequestToLeaveMessage` with the given chat ID.
///
/// This function creates a `RequestToLeaveMessage` with a payload that contains the given chat ID.
/// The message type of the created `RequestToLeaveMessage` is `.leaveRequest`.
///
/// - Parameter chatID: The ID of the chat to include in the payload of the `RequestToLeaveMessage`.
/// - Returns: A `RequestToLeaveMessage` with the given chat ID in its payload.
public func createRequestToLeaveMessage(chatID: Int) -> RequestToLeaveMessage {
    let payload = Payload(chatID: chatID)

    return RequestToLeaveMessage(messageType: .leaveRequest, payload: payload)
}
