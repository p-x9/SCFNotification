import XCTest
@testable import SCFNotification

class SCFDarwinNotificationTests: SCFNotificationTests {
    override var centerType: SCFNotificationCenter.CenterType {
        .darwinNotify
    }

    // Customized
    // object is ignored
    override func testObserveNamedWithObject() {
        let exp = expectation(description: #function)

        notificationCenter
            .addObserver(observer: self,
                         name: .init(#function as CFString),
                         object: "hello" as CFString,
                         suspensionBehavior: .deliverImmediately) { center, observer, name, object, userInfo in
                XCTAssertEqual(observer, self)
                XCTAssertEqual(center?.centerType, self.centerType)
                XCTAssertEqual(name?.rawValue, #function as CFString)
                XCTAssertNil(object)
                exp.fulfill()
            }


        notificationCenter.postNotification(name: .init(#function as CFString),
                                            object: "hello" as CFString,
                                            userInfo: [:] as CFDictionary,
                                            deliverImmediately: true)

        wait(for: [exp], timeout: timeout)
        removeEveryObserver()
    }

    override func testObserveNamedWithObjectShouldNotCalled() {
        let exp = expectation(description: #function)

        notificationCenter
            .addObserver(observer: self,
                         name: .init("\(#function)" as CFString),
                         object: "hello-aaa" as CFString,
                         suspensionBehavior: .deliverImmediately) { center, observer, name, object, userInfo in
                exp.fulfill()
            }


        notificationCenter.postNotification(name: .init(#function as CFString),
                                            object: "hello" as CFString,
                                            userInfo: [:] as CFDictionary,
                                            deliverImmediately: true)

        wait(for: [exp], timeout: timeout)

        removeEveryObserver()
    }

    // Custimized
    // If center is a Darwin notification center, this value must not be NULL.
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

    // Custimized
    // If center is a Darwin notification center, this value must not be NULL.
    override func testObserveNilNamedWithObject() {
        let exp = expectation(description: #function)
        exp.isInverted = true

        notificationCenter
            .addObserver(observer: self,
                         name: nil,
                         object: "hello" as CFString,
                         suspensionBehavior: .deliverImmediately) { center, observer, name, object, userInfo in
                exp.fulfill()
            }


        notificationCenter.postNotification(name: .init(#function as CFString),
                                            object: "hello" as CFString,
                                            userInfo: [:] as CFDictionary,
                                            deliverImmediately: true)

        wait(for: [exp], timeout: timeout)

        removeEveryObserver()
    }
}
