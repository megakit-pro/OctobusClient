//
// Created by Anton Stremovskyy on 23.03.2023.
//

import Foundation

public typealias TypingMessage = Message

public func createTypingMessage(chatID: Int, typing: Bool) -> TypingMessage {
    let payload = Payload(chatID: chatID, isTyping: typing)

    return TypingMessage(messageType: .typing, payload: payload)
}

