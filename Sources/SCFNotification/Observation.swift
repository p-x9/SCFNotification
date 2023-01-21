//
//  Observation.swift
//  
//
//  Created by p-x9 on 2023/01/21.
//  
//

import Foundation

struct Observation {
    typealias SCFNotificationCallbackObjC = (CFNotificationCenter?, UnsafeMutableRawPointer?, CFNotificationName?, UnsafeRawPointer?, CFDictionary?) -> Void
    
    let name: CFString
    var notificationName: CFNotificationName {
        .init(name)
    }
    
    weak var observer: AnyObject?
    weak var object: AnyObject?
    
    var observerPtr: UnsafeMutableRawPointer? {
        guard let observer = self.observer else {
            return nil
        }
        return unsafeBitCast(observer, to: UnsafeMutableRawPointer?.self)
    }
    
    var objectPtr: UnsafeRawPointer? {
        guard let object = self.object else {
            return nil
        }
        return unsafeBitCast(object, to: UnsafeRawPointer?.self)
    }
    
    let notify: SCFNotificationCallbackObjC

    init<Observer: AnyObject, Object: AnyObject>(name: CFString, observer: Observer, object: Object?, notify: SCFNotificationCallback<Observer, Object>?) {
        self.name = name as CFString
        self.observer = observer as AnyObject?
        self.object = object as AnyObject?
        
        self.notify = { center, observerPtr, name, objectPtr, userInfo in
            var observer: Observer?
            if let observerPtr {
                observer = unsafeBitCast(observerPtr, to: Observer?.self)
            }
            var object: Object?
            if let objectPtr,
               center?.centerType != .darwinNotify {
                object = unsafeBitCast(objectPtr, to: Object?.self)
            }
            notify?(center, observer, name, object, userInfo)
        }
    }
}
