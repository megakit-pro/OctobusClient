//
// Created by Anton Stremovskyy on 27.03.2023.
//

import Foundation
import CoreLocation

public typealias LocationBroadcastMessage = Message

public func createLocationBroadcastMessage(chatID: Int, point: CLLocationCoordinate2D) -> LocationBroadcastMessage {
    let payload = Payload(chatID: chatID, latitude: point.latitude, longitude: point.longitude)

    return LocationBroadcastMessage(messageType: .location, payload: payload)
}
