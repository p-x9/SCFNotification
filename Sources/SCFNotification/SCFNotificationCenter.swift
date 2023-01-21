import Foundation

public typealias SCFNotificationCallback<Observer, Object> = (CFNotificationCenter?, Observer?, CFNotificationName?, Object?, CFDictionary?) -> Void


public class SCFNotificationCenter {
    public static let local: SCFNotificationCenter = .init(center: .local)
    public static let darwinNotify: SCFNotificationCenter = .init(center: .darwinNotify)

#if os(macOS)
    public static let distributed: SCFNotificationCenter = .init(center: .distributed)
#endif

    private let center: CenterType

    private init(center: CenterType) {
        self.center = center
    }

    public func addObserver<Observer>(observer: Observer,
                                      name: CFNotificationName,
                                      object: Any? = nil,
                                      suspensionBehavior: CFNotificationSuspensionBehavior,
                                      callback: @escaping SCFNotificationCallback<Observer, Any>) {
        Self.addObserver(center: center,
                         observer: observer,
                         name: name,
                         object: object,
                         suspensionBehavior: suspensionBehavior,
                         callback: callback)
    }

    public func removeObserver<Observer>(observer: Observer,
                                         name: CFNotificationName,
                                         object: Any? = nil) {
        Self.removeObserver(center: center,
                            observer: observer,
                            name: name,
                            object: object)
    }

    public func removeEveryObserver<Observer>(observer: Observer) {
        Self.removeEveryObserver(center: center,
                                 observer: observer)
    }

    public func postNotification(name: CFNotificationName?,
                                 object: Any? = nil,
                                 userInfo: CFDictionary,
                                 deliverImmediately: Bool) {
        Self.postNotification(center: center,
                              name: name,
                              object: object,
                              userInfo: userInfo,
                              deliverImmediately: deliverImmediately)
    }
}


extension SCFNotificationCenter {
    public static func addObserver<Observer>(center: CenterType,
                                             observer: Observer,
                                             name: CFNotificationName,
                                             object: Any? = nil,
                                             suspensionBehavior: CFNotificationSuspensionBehavior,
                                             callback: @escaping SCFNotificationCallback<Observer, Any>) {

        var observation = Observation(name: name.rawValue,
                                      observer: observer,
                                      object: object,
                                      notify: callback)

        if center == .darwinNotify {
            observation.object = nil
        }

        ObservationStore.shared.add(observation, center: center)

        CFNotificationCenterAddObserver(center.cfNotificationCenter, observation.observerPtr, { center, observer, name, object, userInfo in
            guard let center = center?.centerType else { return }
            ObservationStore.shared.notifyIfNeeded(
                center: center,
                observer: observer,
                name: name,
                object: object,
                userInfo: userInfo)
        }, observation.name, observation.objectPtr, suspensionBehavior)
    }

    public static func removeObserver<Observer>(center: CenterType,
                                                observer: Observer,
                                                name: CFNotificationName,
                                                object: Any? = nil) {
        let observer = unsafeBitCast(observer, to: UnsafeMutableRawPointer.self)

        var objectPtr: UnsafeRawPointer?
        if let object {
            objectPtr = unsafeBitCast(object, to: UnsafeRawPointer.self)
        }

        ObservationStore.shared.remove(center: center, observer: observer, object: objectPtr)

        CFNotificationCenterRemoveObserver(center.cfNotificationCenter, observer, name, objectPtr)
    }

    public static func removeEveryObserver<Observer>(center: CenterType,
                                                     observer: Observer) {
        let observer = unsafeBitCast(observer, to: UnsafeMutableRawPointer.self)

        ObservationStore.shared.removeEvery(center: center, observer: observer)
        CFNotificationCenterRemoveEveryObserver(center.cfNotificationCenter, observer)
    }

    public static func postNotification(center: CenterType,
                                        name: CFNotificationName?,
                                        object: Any? = nil,
                                        userInfo: CFDictionary,
                                        deliverImmediately: Bool) {
        var objectPtr: UnsafeRawPointer?
        if let object {
            objectPtr = unsafeBitCast(object, to: UnsafeRawPointer.self)
        }

        CFNotificationCenterPostNotification(center.cfNotificationCenter, name, objectPtr, userInfo, deliverImmediately)
    }
}

extension SCFNotificationCenter {
    public enum CenterType {
        case local, darwinNotify

#if os(macOS)
        case distributed
#endif

        public var cfNotificationCenter: CFNotificationCenter {
            switch self {
            case .local:
                return CFNotificationCenterGetLocalCenter()
            case .darwinNotify:
                return CFNotificationCenterGetDarwinNotifyCenter()
#if os(macOS)
            case .distributed:
                return CFNotificationCenterGetDistributedCenter()
#endif
            }
        }
    }
}
