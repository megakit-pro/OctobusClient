//
//  File.swift
//  
//
//  Created by Anton Stremovskyy on 04.12.2023.
//

import Foundation
import CoreLocation

public typealias LivelocationMessage = Message

public func createliveLocationMessage(chatID: Int, point: CLLocationCoordinate2D) -> LivelocationMessage {
    let payload = Payload(chatID: chatID, latitude: point.latitude, longitude: point.longitude)
    
    return LivelocationMessage(messageType: .location, payload: payload)
}
