//
// Created by Anton Stremovskyy on 25.12.2023.
//

import Foundation

public typealias CommandMessage = Message

public func createCommandMessage(chatID: Int, text: String) -> CommandMessage {
    let payload = Payload(chatID: chatID)

    return CommandMessage(messageType: .commandMessage, payload: payload)
}
