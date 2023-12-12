//
//  File.swift
//  
//
//  Created by Anton Stremovskyy on 04.12.2023.
//

import Foundation
import CoreLocation

/// `LiveLocationMessage` is a type alias for the `Message` type.
public typealias LiveLocationMessage = Message

/// Creates a `LiveLocationMessage` with the given chat ID and location.
///
/// This function creates a `LiveLocationMessage` with a payload that contains the given chat ID and location.
/// The message type of the created `LiveLocationMessage` is `.location`.
///
/// - Parameters:
///   - chatID: The ID of the chat to include in the payload of the `LiveLocationMessage`.
///   - point: The location to include in the payload of the `LiveLocationMessage`. This should be a `CLLocationCoordinate2D` object.
/// - Returns: A `LiveLocationMessage` with the given chat ID and location in its payload.
public func createLiveLocationMessage(chatID: Int, point: CLLocationCoordinate2D) -> LiveLocationMessage {
    let payload = Payload(chatID: chatID, latitude: point.latitude, longitude: point.longitude)

    return LiveLocationMessage(messageType: .location, payload: payload)
}
