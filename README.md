Publish/subscribe to enum events in Swift
===================

This is type-safe publish/subscribe implementation, where you use custom enums as events.

### Events

Inherit Event protocol in your events enum.

```swift
enum User: Event {
    case Followed
    case Unfollowed
}
```

### Subscription

You can subscribe to clojure.

```swift
Eventer.subscribe(Events.User.Followed) { (info) in
  
}
```

And you can subscribe to function or method.

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

And you can publish events with additional info.

```swift
Eventer.publish(Events.Route.Added, info: "Super user")
```
