//
//  MessagePayload.swift
//  Octobus
//
//  Created by Anton Stremovskyy on 09.10.2023.
//

import Foundation

/// `MessagePayload` is a structure that represents the payload of a message.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public struct MessagePayload: Codable {
    /// An optional `Driver` object representing the driver associated with the message.
    public let driver: Driver?
    /// A `String` representing the status of the message.
    public let status: String
    /// An optional `Int` representing the validity period of the message.
    public let validTill: Int?
    /// An optional `String` representing id associated with the message.
    public let id: String?
    /// An optional `Int` representing added value for fare offer.
    public let addedValue: Int?
    /// An optional `String` representing fare offer status.
    public let fareOfferStatus: String?
    /// An optional `Vehicle` representing vehicle associated with the message.
    public let vehicle: Vehicle?

    /// An enumeration that represents the coding keys for the `MessagePayload` structure.
    enum CodingKeys: String, CodingKey {
        case driver, status, id, vehicle
        case validTill = "valid_till"
        case addedValue = "added_value"
        case fareOfferStatus = "fare_offer_status"
    }
}

/// `Driver` is a structure that represents a driver.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public struct Driver: Codable {
    /// An optional `String` representing the avatar of the driver.
    public let avatar: String?
    /// An optional `LOC` object representing the location of the driver.
    public let loc: LOC?
    /// An optional `String` representing the name of the driver.
    public let name: String?
    /// An optional `String` representing the ID of the driver.
    public let id: String?
    /// An optional `Double` representing the rating of the driver.
    public let rating: Double?
}

/// `LOC` is a structure that represents a location.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public struct LOC: Codable {
    /// An optional `Double` representing the latitude of the location.
    public let lat: Double?
    /// An optional `Double` representing the longitude of the location.
    public let lon: Double?
}

/// `Vehicle` is a structure that represents a vehicle.
/// It conforms to the `Codable` protocol for easy encoding and decoding.
public struct Vehicle: Codable {
    /// An optional `String` representing the brand of the vehicle.
    public let brand: String?
    /// An optional `String` representing the model of the vehicle.
    public let model: String?
}
