import XCTest
@testable import SCFNotification

/// NOTE:
///　When I check the pointer of self in the setUp method, it changes every time.
///　Perhaps each time one test method is called, Xcode makes a copy and continues with the rest of the tests.
///　Therefore, each time one method is called, we call the `removeEveryObserver` method at the end of it.

class SCFNotificationTests: XCTestCase {
    var centerType: SCFNotificationCenter.CenterType { .local }
    lazy var notificationCenter: SCFNotificationCenter = .init(center: centerType)
    var observationStore: ObservationStore = .shared

    var timeout: TimeInterval { 1 }

    override func setUp() {
        super.setUp()

        removeEveryObserver()
    }

    func removeEveryObserver() {
        observationStore.cleanUp()

        notificationCenter
            .removeEveryObserver(observer: self)


        XCTAssertTrue(observationStore.observations(for: centerType).isEmpty)
    }

    func testObserveNamed() {
        let exp = expectation(description: #function)

        notificationCenter
            .addObserver(observer: self,
                         name: .init(#function as CFString),
                         suspensionBehavior: .deliverImmediately) { center, observer, name, object, userInfo in
                XCTAssertEqual(observer, self)
                XCTAssertEqual(center?.centerType, self.centerType)
                XCTAssertEqual(name?.rawValue, #function as CFString)
                exp.fulfill()
            }


        notificationCenter.postNotification(name: .init(#function as CFString),
                                            userInfo: [:] as CFDictionary,
                                            deliverImmediately: true)

        wait(for: [exp], timeout: timeout)

        removeEveryObserver()
    }

    func testObserveNamedShouldNotCalled() {
        let exp = expectation(description: #function)
        exp.isInverted = true

        notificationCenter
            .addObserver(observer: self,
                         name: .init("\(#function)-aaa" as CFString),
                         suspensionBehavior: .deliverImmediately) { center, observer, name, object, userInfo in
                exp.fulfill()
            }


        notificationCenter.postNotification(name: .init(#function as CFString),
                                            userInfo: [:] as CFDictionary,
                                            deliverImmediately: true)

        wait(for: [exp], timeout: timeout)

        removeEveryObserver()
    }

    func testObserveNamedWithObject() {
        let exp = expectation(description: #function)

        notificationCenter
            .addObserver(observer: self,
                         name: .init(#function as CFString),
                         object: "hello" as CFString,
                         suspensionBehavior: .deliverImmediately) { center, observer, name, object, userInfo in
                XCTAssertEqual(observer, self)
                XCTAssertEqual(center?.centerType, self.centerType)
                XCTAssertEqual(name?.rawValue, #function as CFString)
                XCTAssertEqual(object as! CFString, "hello" as CFString)
                exp.fulfill()
            }


        notificationCenter.postNotification(name: .init(#function as CFString),
                                            object: "hello" as CFString,
                                            userInfo: [:] as CFDictionary,
                                            deliverImmediately: true)

        wait(for: [exp], timeout: timeout)
        removeEveryObserver()
    }

    func testObserveNamedWithObjectShouldNotCalled() {
        let exp = expectation(description: #function)
        exp.isInverted = true

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

    func testObserveNilNamed() {
        let exp = expectation(description: #function)

        notificationCenter
            .addObserver(observer: self,
                         name: nil,
                         suspensionBehavior: .deliverImmediately) { center, observer, name, object, userInfo in
                XCTAssertEqual(observer, self)
                XCTAssertEqual(center?.centerType, self.centerType)
                XCTAssertEqual(name?.rawValue, #function as CFString)
                exp.fulfill()
            }


        notificationCenter.postNotification(name: .init(#function as CFString),
                                            userInfo: [:] as CFDictionary,
                                            deliverImmediately: true)

        wait(for: [exp], timeout: timeout)

        removeEveryObserver()
    }

    func testObserveNilNamedWithObject() {
        let exp = expectation(description: #function)

        notificationCenter
            .addObserver(observer: self,
                         name: nil,
                         object: "hello" as CFString,
                         suspensionBehavior: .deliverImmediately) { center, observer, name, object, userInfo in
                XCTAssertEqual(observer, self)
                XCTAssertEqual(center?.centerType, self.centerType)
                XCTAssertEqual(name?.rawValue, #function as CFString)
                XCTAssertEqual(object as! CFString, "hello" as CFString)
                exp.fulfill()
            }


        notificationCenter.postNotification(name: .init(#function as CFString),
                                            object: "hello" as CFString,
                                            userInfo: [:] as CFDictionary,
                                            deliverImmediately: true)

        wait(for: [exp], timeout: timeout)

        removeEveryObserver()
    }

    func testObserveNilNamedWithObjectShouldNotCalled() {
        let exp = expectation(description: #function)
        exp.isInverted = true

        notificationCenter
            .addObserver(observer: self,
                         name: nil,
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
}
