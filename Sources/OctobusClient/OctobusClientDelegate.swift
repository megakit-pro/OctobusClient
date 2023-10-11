//
//  File.swift
//  
//
//  Created by Anton Stremovskyy on 10.10.2023.
//

import Foundation

public protocol OctobusClientDelegate: AnyObject {
    func setConnected(_ connected:Bool)
    func setError(_ error: Error)
    func onOctobusMessage(serverMessage: ServerMessage<OctobusMessage>)
    func onOctobusMessages(serverMessage: ServerMessage<[OctobusMessage]>)
}
