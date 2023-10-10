//
//  TextMessage.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 20.03.2023.
//

import Foundation

public typealias ReadConfirmMessage = Message

public func createReadConfirmMessage(chatID: Int, messageId: Int) -> ReadConfirmMessage {
    let payload = Payload(chatID: chatID, messageId: messageId)
    
    return ReadConfirmMessage(messageType: MessageType.readConfirm, payload: payload)
}
