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

You can subscribe to closure.

```swift
Eventer.subscribe(Events.User.Followed) {
  
}
```

And you can subscribe to function or method.

```swift
Eventer.subscribe(Events.User.Unfollowed, action: self.onNeedToReload)
```

Closure or function can be with or without info argument.

```swift
Eventer.subscribe(Events.User.Followed) { (info) in
  
}
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

You can asynchronously publish events in background or main thread.

```swift
Eventer.publish(Events.User.Followed, to: .Background)
Eventer.publish(Events.User.Followed, to: .Main)
```
