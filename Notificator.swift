//  Created by Stanislav Feldman on 27/07/15.
//  Copyright (c) 2015 Stanislav Feldman. All rights reserved.

/**
NSNotificationCenter wrapper.
*/
class Notificator {
    /**
    Subscribe notification action to NSNotification
    
    :param: event Your string event
    
    :param: action Function or closure with notification:NSNotification! argument
    
    :returns: Subscription token
    */
    class func subscribe(event: String, action: Action.NotificationAction) -> NSObjectProtocol {
        return NSNotificationCenter.defaultCenter().addObserverForName(event, object: nil, queue: nil, usingBlock: action)
    }
    
    /**
    Subscribe notification action to NSNotification
    
    :param: token Subscription token
    */
    class func unsubscribe(token: NSObjectProtocol) {
        NSNotificationCenter.defaultCenter().removeObserver(token)
    }
}
