//
// Created by Anton Stremovskyy on 27.03.2023.
//

import Foundation

public typealias CommitMassage = Message

public func createCommitMassage(lastUpdateID: Int) -> CommitMassage {
    let payload = Payload(latestUpdateId: lastUpdateID)

    return CommitMassage(messageType: .commitUpdates, payload: payload)
}
