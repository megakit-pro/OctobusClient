import XCTest
@testable import OctobusClient

class OctobusClientTests: XCTestCase {
    var client: OctobusClient!
    var mockDelegate: MockNetworkManagerDelegate!

    override func setUp() {
        super.setUp()
        client = OctobusClient()
        mockDelegate = MockNetworkManagerDelegate()
        
        client.delegate = mockDelegate
    }

    override func tearDown() {
        client = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testConnect() {
        let token = ""
        
        client.connect(to: "ws://localhost:10188/octobus/v1/passenger/ws", with: token)

        sleep(1)

        XCTAssertTrue(mockDelegate.didSetConnected, "Connection wasn't established.")
    }

}

// MARK: - MockNetworkManagerDelegate
class MockNetworkManagerDelegate: OctobusClientDelegate {
    deinit {
        print("MockNetworkManagerDelegate deinitialized!")
    }


    var didSetConnected = false
    var didSetError: Error?
    var didHandleIncomingMessage: ServerMessage<OctobusMessage>?
    var didHandleIncomingMessages: ServerMessage<[OctobusMessage]>?

    func setConnected(_ connected: Bool) {
        didSetConnected = connected
    }

    func setError(_ error: Error) {
        didSetError = error
    }

    func onOctobusMessage(serverMessage: ServerMessage<OctobusMessage>) {
        didHandleIncomingMessage = serverMessage
    }

    func onOctobusMessages(serverMessage: ServerMessage<[OctobusMessage]>) {
        didHandleIncomingMessages = serverMessage
    }

    func authenticationFailed() {
        didSetError = Error.self as? Error
    }
}
