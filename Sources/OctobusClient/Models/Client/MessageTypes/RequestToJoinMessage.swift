//
// Created by Anton Stremovskyy on 22.03.2023.
//

import Foundation


public typealias RequestToJoinMessage = Message

public func createRequestToJoinMessage(chatID: Int) -> RequestToJoinMessage {
    let payload = Payload(chatID: chatID)

    return RequestToJoinMessage(messageType: .joinRequest, payload: payload)
}

public func createRequestToJoinMessage(requestUUID: String) -> RequestToJoinMessage {
    let payload = Payload(requestUuid: requestUUID)

    return RequestToJoinMessage(messageType: .joinRequest, payload: payload)
}
