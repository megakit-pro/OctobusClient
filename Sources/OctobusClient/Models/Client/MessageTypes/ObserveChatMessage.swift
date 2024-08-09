//
//  ObserveChatMessage.swift
//
//
//  Created by Victor on 07.08.2024.
//

import Foundation

public typealias ObserveChatMessage = Message

public func createObserveChatMessage(chatUUID: String) -> ObserveChatMessage {
    let payload = Payload(chatUUID: chatUUID)

    return ObserveChatMessage(messageType: .startObservingChat, payload: payload)
}
