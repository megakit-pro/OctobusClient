//
//  OctobusClientDelegate.swift
//
//
//  Created by Anton Stremovskyy on 10.10.2023.
//
import Foundation

/// `OctobusClientDelegate` is a protocol that defines the delegate methods for an Octobus client.
public protocol OctobusClientDelegate: AnyObject {

    /// Notifies the delegate that the connection status has changed.
    ///
    /// - Parameter connected: A Boolean value indicating whether the client is connected.
    func setConnected(_ connected:Bool)

    /// Notifies the delegate that an error has occurred.
    ///
    /// - Parameter error: The error that occurred.
    func setError(_ error: Error)

    /// Notifies the delegate that a single Octobus message has been received.
    ///
    /// - Parameter serverMessage: The server message containing the Octobus message.
    func onOctobusMessage(serverMessage: ServerMessage<OctobusMessage>)

    /// Notifies the delegate that multiple Octobus messages have been received.
    ///
    /// - Parameter serverMessage: The server message containing the array of Octobus messages.
    func onOctobusMessages(serverMessage: ServerMessage<[OctobusMessage]>)
    
    /// Notifies the delegate that unhandled data has been received.
    ///
    /// - Parameter data: Data from server that couldn't be represented in any handled type.
    func onOctobusData(_ data: Data)

    /// Notifies the delegate that authentication has failed.
    func authenticationFailed()
}
