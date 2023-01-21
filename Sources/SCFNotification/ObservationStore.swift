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

    func remove(center: SCFNotificationCenter.CenterType,
                observer: UnsafeMutableRawPointer?,
                name: CFNotificationName?,
                object: UnsafeRawPointer?) {
        cleanUp()

        switch center {
        case .local:
            localObservations = localObservations
                .remove(observer: observer, name: name, object: object)
        case .darwinNotify:
            darwinNotifyObservations = darwinNotifyObservations
                .remove(observer: observer, name: name, object: object)
#if os(macOS)
        case .distributed:
            distributedObservations = distributedObservations
                .remove(observer: observer, name: name, object: object)
#endif
        }
    }

    func removeEvery(center: SCFNotificationCenter.CenterType, observer: UnsafeMutableRawPointer?) {
        cleanUp()

        switch center {
        case .local:
            localObservations = localObservations
                .removeEvery(observer: observer)
        case .darwinNotify:
            darwinNotifyObservations = darwinNotifyObservations
                .removeEvery(observer: observer)
#if os(macOS)
        case .distributed:
            distributedObservations = distributedObservations
                .removeEvery(observer: observer)
#endif
        }
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
            .notifyNeededOnly(observer: observer, name: name, object: object)
            .forEach {
                $0.notify(center.cfNotificationCenter, observer, name, object, userInfo)
            }
    }

}
