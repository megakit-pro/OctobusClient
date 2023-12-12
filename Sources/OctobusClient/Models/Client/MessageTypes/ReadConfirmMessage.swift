//
//  TextMessage.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 20.03.2023.
//

import Foundation

/// `ReadConfirmMessage` is a type alias for the `Message` type.
public typealias ReadConfirmMessage = Message

/// Creates a `ReadConfirmMessage` with the given chat ID and message ID.
///
/// This function creates a `ReadConfirmMessage` with a payload that contains the given chat ID and message ID.
/// The message type of the created `ReadConfirmMessage` is `.readConfirm`.
///
/// - Parameters:
///   - chatID: The ID of the chat to include in the payload of the `ReadConfirmMessage`.
///   - messageId: The ID of the message to include in the payload of the `ReadConfirmMessage`.
/// - Returns: A `ReadConfirmMessage` with the given chat ID and message ID in its payload.
public func createReadConfirmMessage(chatID: Int, messageId: Int) -> ReadConfirmMessage {
    let payload = Payload(chatID: chatID, messageId: messageId)

    return ReadConfirmMessage(messageType: MessageType.readConfirm, payload: payload)
}
