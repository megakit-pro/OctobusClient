//
// Created by Anton Stremovskyy on 25.12.2023.
//

import Foundation

public enum UserActionType: Int, Codable {
    case kick = 1
    case ban = 2
    case mute = 3
}

public typealias UserActionMessage = Message

public func createUserActionMessage(chatID: Int, userID: Int, action: UserActionType) -> UserActionMessage {
    let payload = Payload(chatID: chatID, action: action, userID: userID)

    return UserActionMessage(messageType: .userAction, payload: payload)
}
