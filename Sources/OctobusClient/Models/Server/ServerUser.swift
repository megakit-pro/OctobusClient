//
//  ServerUser.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 21.03.2023.
//

import Foundation

/// `ServerUser` is a structure that represents a user on the server.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public struct ServerUser: Codable {
    public let id: Int
    /// An `Int` representing the ID of the user.
    public let userID: Int
    /// A `UserType` representing the type of the user.
    public let userType: UserType
    /// An optional `String` representing the name of the user.
    public let name: String?

    /// An enumeration that represents the coding keys for the `ServerUser` structure.
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case userType = "user_type"
        case name
    }
}

/// `UserType` is an enumeration that represents different types of users.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public enum UserType: String, Codable {
    case bot = "bot"
    case passenger = "passenger"
    case driver = "driver"
    case dispatcher = "dispatcher"
    case system = "system"
    case unknown = "unknown"
}
