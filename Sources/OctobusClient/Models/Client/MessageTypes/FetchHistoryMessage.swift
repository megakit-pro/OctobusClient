//
// Created by Anton Stremovskyy on 25.12.2023.
//

import Foundation

/// `FetchHistoryMessage` is a type alias for the `Message` type.
public typealias FetchHistoryMessage = Message

public func createFetchHistoryMessage(requestUUID: String) -> FetchHistoryMessage {
    let payload = Payload(chatUUID: requestUUID)

    return FetchHistoryMessage(messageType: .getChatUpdates, payload: payload)
}
