//
//  Array+.swift
//  
//
//  Created by p-x9 on 2023/01/21.
//  
//

import Foundation

extension Array where Element == Observation {
    func remove(observer: UnsafeMutableRawPointer?, name: CFNotificationName?, object: UnsafeRawPointer?) -> Array<Element> {
        filter {
            guard $0.observerPtr == observer,
                  $0.objectPtr == object else {
                return true
            }

            // if name is nil, remove all
            if let name {
                return !($0.name == name.rawValue)
            }
            return false
        }
    }

    func removeEvery(observer: UnsafeMutableRawPointer?) -> Array<Element> {
        filter {
            guard $0.observerPtr == observer else {
                return true
            }
            return false
        }
    }

    func cleanUpped() -> Array<Element> {
        filter {
            $0.observer != nil
        }
    }

    func notifyNeededOnly(observer: UnsafeMutableRawPointer?, name: CFNotificationName?, object: UnsafeRawPointer?) -> Array<Element> {
        filter {
            var isFiltered = true

            guard observer == $0.observerPtr else {
                return false
            }

            // if name is nil, observe all notification
            if $0.name != nil {
                isFiltered = name?.rawValue == $0.name
            }

            // if object is nil, observe all notification
            if let objectPtr = $0.objectPtr {
                isFiltered = (object == objectPtr) && isFiltered
            }

            return isFiltered
        }
    }
}
