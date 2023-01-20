import Foundation

public typealias SCFNotificationCallback<Observer, Object> = (CFNotificationCenter?, Observer?, CFNotificationName?, Object?, CFDictionary?) -> Void


public enum SCFNotificationCenter {
    public static func addObserver<Observer>(center: CenterType,
                                             observer: Observer,
                                             name: CFNotificationName,
                                             object: Any? = nil,
                                             suspensionBehavior: CFNotificationSuspensionBehavior,
                                             callback: @escaping SCFNotificationCallback<Observer, Any>) {

        let observation = Observation(name: name.rawValue,
                                      observer: observer,
                                      object: object,
                                      notify: callback)

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
