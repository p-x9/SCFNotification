# SCFNotification

Swift wrapper of `CFNotificationCenter`.
No more tedious type conversions using pointers.

[CFNotificationCenter](https://developer.apple.com/documentation/corefoundation/cfnotificationcenter-rkv)
## Usage

### CenterTypes
- local
  (CFNotificationCenterGetLocalCenter)
- darwinNotify
  (CFNotificationCenterGetDarwinNotifyCenter)
- distributed (macOS only)
  (CFNotificationCenterGetDistributedCenter)
### import
```swift
import SCFNotification
```

### addObserver
```swift
SCFNotificationCenter
            .addObserver(center: .local,
                         observer: self,
                         name: .init("local.notification" as CFString),
                         suspensionBehavior: .deliverImmediately) { center, `self`, name, object, userInfo in
                print(center, name, object, userInfo)
            }

/*  or  */

SCFNotificationCenter.local
            .addObserver(observer: self,
                         name: .init("local.notification" as CFString),
                         suspensionBehavior: .deliverImmediately) { center, `self`, name, object, userInfo in
                self?.show()
                print(center, name, object, userInfo)
            }
```

### postNotification
```swift
SCFNotificationCenter
            .postNotification(center: .local,
                              name: .init("local.notification" as CFString),
                              userInfo: [:] as CFDictionary,
                              deliverImmediately: true
            )

/*  or  */

SCFNotificationCenter.local
            .postNotification(name: .init("local.notification" as CFString),
                              userInfo: [:] as CFDictionary,
                              deliverImmediately: true
            )
```

### removeObserver
```swift
SCFNotificationCenter
            .removeObserver(center: .local,
                            observer: self,
                            name: .init("local.notification" as CFString)
            )

/*  or  */

SCFNotificationCenter.local
            .removeObserver(observer: self,
                            name: .init("local.notification" as CFString)
            )
```
