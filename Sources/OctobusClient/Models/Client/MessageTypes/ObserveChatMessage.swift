//
//  ObserveChatMessage.swift
//
//
//  Created by Victor on 07.08.2024.
//

import Foundation

public typealias ObserveChatMessage = Message

public func createObserveChatMessage(chatID: Int) -> ObserveChatMessage {
    let payload = Payload(chatID: chatID)

    return ObserveChatMessage(messageType: .startObservingChat, payload: payload)
}
