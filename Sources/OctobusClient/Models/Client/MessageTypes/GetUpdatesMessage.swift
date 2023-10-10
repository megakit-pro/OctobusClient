//
// Created by Anton Stremovskyy on 20.03.2023.
//

import Foundation

public typealias GetUpdatesMessage = Message

public func createGetAllUpdatesMessage(offset: Int? = 0, limit: Int? = 100) -> GetUpdatesMessage {
    let payload = Payload(limit: limit, offset: offset)

    return GetUpdatesMessage(messageType: .getUpdates, payload: payload)
}

public func createGetUpdatesMessage() -> GetUpdatesMessage {
    let payload = Payload()

    return GetUpdatesMessage(messageType: .getUpdates, payload: payload)
}
