//
// Created by Anton Stremovskyy on 23.03.2023.
//

import Foundation

/// `TypingMessage` is a type alias for the `Message` type.
public typealias TypingMessage = Message

/// Creates a `TypingMessage` with the given chat ID and typing status.
///
/// This function creates a `TypingMessage` with a payload that contains the given chat ID and typing status.
/// The message type of the created `TypingMessage` is `.typing`.
///
/// - Parameters:
///   - chatID: The ID of the chat to include in the payload of the `TypingMessage`.
///   - typing: The typing status to include in the payload of the `TypingMessage`.
/// - Returns: A `TypingMessage` with the given chat ID and typing status in its payload.
public func createTypingMessage(chatID: Int, typing: Bool) -> TypingMessage {
    let payload = Payload(chatID: chatID, isTyping: typing)

    return TypingMessage(messageType: .typing, payload: payload)
}
