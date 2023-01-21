import XCTest
@testable import SCFNotification

class SCFDistributedNotificationTests: SCFNotificationTests {
    override var centerType: SCFNotificationCenter.CenterType {
        .distributed
    }

    // Custimized
    // For distributed notifications, object must be a CFString object ?
    override func testObserveNilNamed() {
        let exp = expectation(description: #function)
        exp.isInverted = true

        notificationCenter
            .addObserver(observer: self,
                         name: nil,
                         suspensionBehavior: .deliverImmediately) { center, observer, name, object, userInfo in
                exp.fulfill()
            }

        notificationCenter.postNotification(name: .init(#function as CFString),
                                            userInfo: [:] as CFDictionary,
                                            deliverImmediately: true)

        wait(for: [exp], timeout: timeout)

        removeEveryObserver()
    }
}
