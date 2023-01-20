//
//  Array+.swift
//  
//
//  Created by p-x9 on 2023/01/21.
//  
//

import Foundation

extension Array where Element == Observation {
    func filterWith(observer: UnsafeMutableRawPointer?, object: UnsafeRawPointer?) -> Array<Element> {
        filter {
            guard $0.observerPtr == observer,
                  $0.objectPtr == object else {
                return false
            }
            return true
        }
    }


    func filterWith(observer: UnsafeMutableRawPointer?) -> Array<Element> {
        filter {
            guard $0.observerPtr == observer else {
                return false
            }
            return true
        }
    }

    func remove(observer: UnsafeMutableRawPointer?, object: UnsafeRawPointer?) -> Array<Element> {
        filter {
            guard $0.observerPtr == observer,
                  $0.objectPtr == object else {
                return true
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
}
