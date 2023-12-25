//
// Created by Anton Stremovskyy on 25.12.2023.
//

import Foundation

public enum ReportType: Int, Codable {
    case spam = 1
    case violence = 2
    case pornography = 3
    case personalDetails = 4
    case abuse = 5
    case other = 6

    enum CodingKeys: String, CodingKey {
        case personalDetails = "personal_details"
    }
}

public typealias ReportToMessage = Message

public func createReportToMessage(chatID: Int, MessageID: Int, ReportType: ReportType) -> ReportToMessage {
    let payload = Payload(chatID: chatID, messageId: MessageID, reportType: ReportType)

    return ReportToMessage(messageType: .reportToMessage, payload: payload)
}
