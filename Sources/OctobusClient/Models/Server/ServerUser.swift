//
//  ServerUser.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 21.03.2023.
//

import Foundation


// MARK: - User
public struct ServerUser: Codable {
    public let userID: Int
    public let userType: UserType
    public let name: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userType = "user_type"
        case name
    }
}

public enum UserType: String, Codable {
    case bot = "bot"
    case passenger = "passenger"
    case driver = "driver"
    case dispatcher = "dispatcher"
    case system = "system"
    case unknown = "unknown"
}
