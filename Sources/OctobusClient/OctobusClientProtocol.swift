//
//  File.swift
//  
//
//  Created by Anton Stremovskyy on 10.10.2023.
//

import Foundation

public protocol OctobusClientProtocol {
    func connect(to url: String?, with token: String?)
    func disconnect()
    func send(message: Message)
}
