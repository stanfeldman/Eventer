Publish/subscribe to enum events in Swift
===================

This is type-safe publish/subscribe implementation, where you use custom enums as events.

### Events

You inherite Event protocol in your events enum.

```swift
enum User: Event {
    case Followed
    case Unfollowed
}
```

### Subscription

You can use clojures as callbacks.

```swift
Eventer.subscribe(Events.User.Followed) { (info) in
  
}
```

And functions as well.

```swift
Eventer.subscribe(Events.User.Unfollowed, action: self.onNeedToReload)
```

You can use subscribe to several events.

```swift
Eventer.subscribe([Events.User.Followed, Events.User.Unfollowed], action: self.onNeedToReload)
```

### Publishing

You can publish events defined in custom enums.

```swift
Eventer.publish(Events.User.Followed)
```

You can publish events with additional info.

```swift
Eventer.publish(Events.Route.Added, info: "Super user")
```
