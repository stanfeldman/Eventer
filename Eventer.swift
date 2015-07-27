//  Created by Stanislav Feldman on 26/07/15.
//  Copyright (c) 2015 Stanislav Feldman. All rights reserved.

import Foundation


/**
Inherit your Events enum from this protocol.
*/
protocol Event: Hashable {}


/**
Type-safe publish/subscribe implementation, where you use custom enums as events.
Use static functions to publish/subscribe on events.
*/
class Eventer<EventType: Event> {
    /**
    Publish event
    
    :param: event Your event
    */
    class func publish(event: EventType) {
        publish(event, to:.Immediate)
    }
    
    /**
    Publish event to execution type
    
    :param: event Your event
    
    :param: to Execution type: Immediate, Background or Main
    */
    class func publish(event: EventType, to:Action.Execution) {
        publish(event, info: nil, to:to)
    }
    
    /**
    Publish event with info: AnyObject?
    
    :param: event Your event
    
    :param: info Any object you want to pass to actions
    */
    class func publish(event: EventType, info: AnyObject?) {
        publish(event, info: info, to:.Immediate)
    }
    
    /**
    Publish event with info: AnyObject? and execution type
    
    :param: event Your event
    
    :param: info Any object you want to pass to actions
    
    :param: to Execution type: Immediate, Background or Main
    */
    class func publish(event: EventType, info: AnyObject?, to:Action.Execution) {
        for action in Eventer.sharedInstance.actions {
            if action.event == event {
                action.action.execute(info, execution:to)
            }
        }
    }
    
    /**
    Subscribe action to event
    
    :param: event Your event
    
    :param: action Function or closure without argument
    
    :returns: Subscription token
    */
    class func subscribe(event: EventType, action: Action.SimpleAction) -> String {
        return subscribe([event], action: action)
    }
    
    /**
    Subscribe action to array of events
    
    :param: events Array of events
    
    :param: action Function or closure without argument
    
    :returns: Subscription token
    */
    class func subscribe(events: [EventType], action: Action.SimpleAction) -> String {
        let token = NSUUID().UUIDString
        let eventer = Eventer.sharedInstance
        for event in events {
            eventer.actions.append((token:token, event:event, action:Action.Simple(action)))
        }
        return token
    }
    
    /**
    Subscribe info action to event
    
    :param: event Your event
    
    :param: action Function or closure with info:AnyObject? argument
    
    :returns: Subscription token
    */
    class func subscribe(event: EventType, action: Action.InfoAction) -> String {
        return subscribe([event], action: action)
    }
    
    /**
    Subscribe info action to array of events
        
    :param: events Array of events
    
    :param: action Function or closure with info:AnyObject? argument
    
    :returns: Subscription token
    */
    class func subscribe(events: [EventType], action: Action.InfoAction) -> String {
        let token = NSUUID().UUIDString
        let eventer = Eventer.sharedInstance
        for event in events {
            eventer.actions.append((token:token, event:event, action:Action.Info(action)))
        }
        return token
    }
    
    /**
    Unsubscribe action for event with specific token
    
    :param: event Your event
    
    :param: token Subscription token
    */
    class func unsubscribe(event: EventType, token: String) {
        let eventer = Eventer.sharedInstance
        var index = 0
        for action in eventer.actions {
            if action.token == token {
                eventer.actions.removeAtIndex(index)
                break
            }
            index += 1
        }
    }
    
    /**
    Unsubscribe all actions from this event
    
    :param: event Your event
    */
    class func unsubscribe(event: EventType) {
        let eventer = Eventer.sharedInstance
        var index = 0
        for action in eventer.actions {
            if action.event == event {
                eventer.actions.removeAtIndex(index)
            }
            index += 1
        }
    }
    
    static var sharedInstance:Eventer<EventType> {
        for eventerInstance in __eventerInstances {
            if let instance = eventerInstance as? Eventer<EventType> {
                return instance
            }
        }
        let eventer = Eventer<EventType>()
        __eventerInstances.append(eventer)
        return eventer
    }
    
    typealias Subscription = (token:String, event:EventType, action:Action)
    private var actions = [Subscription]()
}
/**
Do not change it! Internal variable for holding Eventer instances.
*/
var __eventerInstances = [AnyObject]()

