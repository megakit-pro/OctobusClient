//
//  ServerChat.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 21.03.2023.
//

import Foundation



// MARK: - Chat
public struct ServerChat: Codable {
    public let id: Int
    public let requestUUID: String
    public let isSealed: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case requestUUID = "request_uuid"
        case isSealed = "is_sealed"
    }
}
