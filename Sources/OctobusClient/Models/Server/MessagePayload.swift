//
//  MessagePayload.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 09.10.2023.
//

import Foundation

    // MARK: - MessagePayload
public struct MessagePayload: Codable {
    public let driver: Driver?
    public let status, validTill: String?
    
    enum CodingKeys: String, CodingKey {
        case driver, status
        case validTill = "valid_till"
    }
}

    // MARK: - Driver
public struct Driver: Codable {
    public let avatar: String?
    public let loc: LOC?
    public let name: String?
}

    // MARK: - LOC
public struct LOC: Codable {
    public let lat, lon: String?
}
