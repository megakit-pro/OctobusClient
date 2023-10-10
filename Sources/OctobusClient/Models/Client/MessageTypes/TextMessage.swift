//
//  TextMessage.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 20.03.2023.
//

import Foundation

public typealias TextMessage = Message

public func createTextMessage(chatID: Int, text: String) -> TextMessage {
    let payload = Payload(chatID: chatID, text: text)
    
    return TextMessage(messageType: MessageType.text, payload: payload)
}
