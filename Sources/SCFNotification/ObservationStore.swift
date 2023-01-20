//
//  ObservationStore.swift
//  
//
//  Created by p-x9 on 2023/01/21.
//  
//

import Foundation

class ObservationStore {
    static let shared = ObservationStore()

    private(set) var localObservations = [Observation]()
    private(set) var darwinNotifyObservations = [Observation]()

#if os(macOS)
    private(set) var distributedObservations = [Observation]()
#endif

    private init() {}

    func add(_ observation: Observation, center: SCFNotificationCenter.CenterType) {
        cleanUp()

        switch center {
        case .local:
            localObservations.append(observation)
        case .darwinNotify:
            darwinNotifyObservations.append(observation)
#if os(macOS)
        case .distributed:
            distributedObservations.append(observation)
#endif
        }
    }

    func remove(center: SCFNotificationCenter.CenterType, observer: UnsafeMutableRawPointer?, object: UnsafeRawPointer?) {
        cleanUp()

        let observation: Observation?
        switch center {
        case .local:
            observation = localObservations
                .filterWith(observer: observer, object: object)
                .first
            localObservations = localObservations
                .remove(observer: observer, object: object)
        case .darwinNotify:
            observation = darwinNotifyObservations
                .filterWith(observer: observer, object: object)
                .first
            darwinNotifyObservations = darwinNotifyObservations
                .remove(observer: observer, object: object)
#if os(macOS)
        case .distributed:
            observation = distributedObservations
                .filterWith(observer: observer, object: object)
                .first
            distributedObservations = distributedObservations
                .remove(observer: observer, object: object)
#endif
        }

        guard let observation else { return }
        CFNotificationCenterRemoveObserver(center.cfNotificationCenter, observation.observerPtr, observation.notificationName, observation.objectPtr)
    }

    func removeEvery(center: SCFNotificationCenter.CenterType, observer: UnsafeMutableRawPointer?) {
        cleanUp()

        let observation: Observation?
        switch center {
        case .local:
            observation = localObservations
                .filterWith(observer: observer)
                .first
            localObservations = localObservations
                .removeEvery(observer: observer)
        case .darwinNotify:
            observation = darwinNotifyObservations
                .filterWith(observer: observer)
                .first
            darwinNotifyObservations = darwinNotifyObservations
                .removeEvery(observer: observer)
#if os(macOS)
        case .distributed:
            observation = distributedObservations
                .filterWith(observer: observer)
                .first
            distributedObservations = distributedObservations
                .removeEvery(observer: observer)
#endif
        }

        guard let observation else { return }
        CFNotificationCenterRemoveEveryObserver(center.cfNotificationCenter, observation.observerPtr)
    }

    func cleanUp() {
        localObservations = localObservations.cleanUpped()

        darwinNotifyObservations = darwinNotifyObservations.cleanUpped()
    }

    func notifyIfNeeded(center: SCFNotificationCenter.CenterType, observer: UnsafeMutableRawPointer?, name: CFNotificationName?, object: UnsafeRawPointer?, userInfo: CFDictionary?) {
        cleanUp()

        let observations: [Observation]
        switch center {
        case .local:
            observations = localObservations
        case .darwinNotify:
            observations = darwinNotifyObservations
#if os(macOS)
        case .distributed:
            observations = distributedObservations
#endif
        }

        observations
            .filterWith(observer: observer, object: object)
            .forEach {
                $0.notify(center.cfNotificationCenter, observer, name, object, userInfo)
            }
    }

}
