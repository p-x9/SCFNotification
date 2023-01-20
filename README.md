# SCFNotification

Swift wrapper of `CFNotificationCenter`.  
No more tedious type conversions using pointers.

## Usage
import
```swift
import SCFNotification
```

addObserver
```swift
SCFNotificationCenter
            .addObserver(center: .local,
                         observer: self,
                         name: .init("local.notification" as CFString),
                         suspensionBehavior: .deliverImmediately) { center, `self`, name, object, userInfo in
                print(center, name, object, userInfo)
            }
```

postNotification
```swift
SCFNotificationCenter
            .postNotification(center: .local,
                              name: .init("local.notification" as CFString),
                              userInfo: [:] as CFDictionary,
                              deliverImmediately: true
            )

```

removeObserver
```swift
SCFNotificationCenter
            .removeObserver(center: .local,
                            observer: self,
                            name: .init("local.notification" as CFString)
            )
```
