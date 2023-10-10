//
//  RequestLeaveChat.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 23.03.2023.
//

import Foundation

public typealias RequestToLeaveMessage = Message

public func createRequestToLeaveMessage(chatID: Int) -> RequestToLeaveMessage {
    let payload = Payload(chatID: chatID)

    return RequestToLeaveMessage(messageType: .leaveRequest, payload: payload)
}
