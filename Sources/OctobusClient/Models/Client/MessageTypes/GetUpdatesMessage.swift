//
// Created by Anton Stremovskyy on 20.03.2023.
//

import Foundation
import Foundation

/// `GetUpdatesMessage` is a type alias for the `Message` type.
public typealias GetUpdatesMessage = Message

/// Creates a `GetUpdatesMessage` with the given offset and limit.
///
/// This function creates a `GetUpdatesMessage` with a payload that contains the given offset and limit.
/// The message type of the created `GetUpdatesMessage` is `.getUpdates`.
///
/// - Parameters:
///   - offset: The offset to include in the payload of the `GetUpdatesMessage`. Default is 0.
///   - limit: The limit to include in the payload of the `GetUpdatesMessage`. Default is 100.
/// - Returns: A `GetUpdatesMessage` with the given offset and limit in its payload.
public func createGetAllUpdatesMessage(offset: Int? = 0, limit: Int? = 100) -> GetUpdatesMessage {
    let payload = Payload(limit: limit, offset: offset)

    return GetUpdatesMessage(messageType: .getUpdates, payload: payload)
}

/// Creates a `GetUpdatesMessage` with an empty payload.
///
/// This function creates a `GetUpdatesMessage` with an empty payload.
/// The message type of the created `GetUpdatesMessage` is `.getUpdates`.
///
/// - Returns: A `GetUpdatesMessage` with an empty payload.
public func createGetUpdatesMessage() -> GetUpdatesMessage {
    let payload = Payload()

    return GetUpdatesMessage(messageType: .getUpdates, payload: payload)
}
