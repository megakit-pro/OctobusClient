# README for OctobusClient

## Introduction

`OctobusClient` is a Swift package that facilitates WebSocket communications, tailored specifically for the Octobus ecosystem. With the added capability of Gzip compression and robust event handling, it's designed to be a powerful and reliable WebSocket client.

## Features

- Establish WebSocket connections with ease.
- Send and receive Gzipped messages.
- Comprehensive logging for effective debugging.
- Built upon the powerful [Starscream](https://github.com/daltoniam/Starscream) library.

## Installation

### Swift Package Manager

To integrate `OctobusClient` into your Xcode project using Swift Package Manager, add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/megakit-pro/OctobusClient.git", from: "1.0.0")
]
```

Replace `1.0.0` with the latest version if necessary.

## Usage

### Creating a Client Instance

```swift
let client = OctobusClient()
client.delegate = self  // Make sure to implement the OctobusClientDelegate protocol
```

### Connecting to a Server

```swift
let token = "YOUR_ACCESS_TOKEN"
client.connect(to: "ws://your.server.url/path", with: token)
```

### Sending Messages

To send messages:

```swift
let message = Message(/* Your message content here */)
client.send(message: message)
```

**Note**: Ensure that your message conforms to the `Message` protocol expected by the `send(message:)` method.

### Delegate Methods

Implement the `OctobusClientDelegate` protocol to handle various events:

- `setConnected(_:)`: Called when the connection status changes.
- `handleIcommingMessage(data:)`: Handles incoming messages.
- `setError(_:)`: Called when an error occurs.

## Dependencies

- [GzipSwift](https://github.com/1024jp/GzipSwift): For Gzip compression and decompression.
- [Starscream](https://github.com/daltoniam/Starscream): A reliable WebSocket library for Swift.

## Contributing

We welcome contributions! Please see the [CONTRIBUTING.md](https://github.com/megakit-pro/OctobusClient/blob/main/CONTRIBUTING.md) file for details.

## License

Please refer to the [LICENSE](https://github.com/megakit-pro/OctobusClient/blob/main/LICENSE) file for details on the license.
