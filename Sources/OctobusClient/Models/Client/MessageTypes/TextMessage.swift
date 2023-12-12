//
//  TextMessage.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 20.03.2023.
//

import Foundation

/// `TextMessage` is a type alias for the `Message` type.
public typealias TextMessage = Message

/// Creates a `TextMessage` with the given chat ID and text.
///
/// This function creates a `TextMessage` with a payload that contains the given chat ID and text.
/// The message type of the created `TextMessage` is `.text`.
///
/// - Parameters:
///   - chatID: The ID of the chat to include in the payload of the `TextMessage`.
///   - text: The text to include in the payload of the `TextMessage`.
/// - Returns: A `TextMessage` with the given chat ID and text in its payload.
public func createTextMessage(chatID: Int, text: String) -> TextMessage {
    let payload = Payload(chatID: chatID, text: text)

    return TextMessage(messageType: MessageType.text, payload: payload)
}
