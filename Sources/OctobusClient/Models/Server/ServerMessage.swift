//
//  ServerMessage.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 20.03.2023.
//

import Foundation

public enum PayloadType: String, Codable {
    case updates
    case broadcast
    case connect
    case disconnect
    case error
}

// MARK: - ServerMessage
public struct ServerMessage<T: Codable>: Codable {
    public let payload: T
    public let type: PayloadType
}

extension ServerMessage {
    public init(data: Data) throws {
        try self = JSONDecoder().decode(ServerMessage<T>.self, from: data)
    }

    public func isNeedToShow() -> Bool {
        type == .updates
    }
}

