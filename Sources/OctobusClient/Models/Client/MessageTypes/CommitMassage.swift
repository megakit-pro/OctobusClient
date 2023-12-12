//
// Created by Anton Stremovskyy on 27.03.2023.
//
import Foundation

/// `CommitMassage` is a type alias for the `Message` type.
public typealias CommitMassage = Message

/// Creates a `CommitMassage` with the given last update ID.
///
/// This function creates a `CommitMassage` with a payload that contains the given last update ID.
/// The message type of the created `CommitMassage` is `.commitUpdates`.
///
/// - Parameter lastUpdateID: The last update ID to include in the payload of the `CommitMassage`.
/// - Returns: A `CommitMassage` with the given last update ID in its payload.
public func createCommitMassage(lastUpdateID: Int) -> CommitMassage {
    let payload = Payload(latestUpdateId: lastUpdateID)

    return CommitMassage(messageType: .commitUpdates, payload: payload)
}
