//
//  File.swift
//  
//
//  Created by Anton Stremovskyy on 16.04.2024.
//

import Foundation

public func createRequestDetailsMessage(requestUUID: String) -> RequestToJoinMessage {
    let payload = Payload(requestUuid: requestUUID)
    
    return RequestToJoinMessage(messageType: .getRequestDetails, payload: payload)
}
