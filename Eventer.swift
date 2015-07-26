//
//  SEV.swift
//  whereabout
//
//  Created by Stanislav Feldman on 26/07/15.
//  Copyright (c) 2015 Limehat. All rights reserved.
//

/**
Inherit your Events enum from this protocol.
*/
protocol Event: Hashable {}


enum Action {
    typealias SimpleAction = () -> Void
    typealias InfoAction = (info: AnyObject?) -> Void
    
    case Simple(SimpleAction)
    case Info(InfoAction)
    
    func execute() {
        execute(nil)
    }
    
    func execute(info: AnyObject?) {
        switch self {
            case .Simple(let action):
                action()
            case .Info(let action):
                action(info: info)
            default:
                break
        }
    }
}


/**
Type-safe publish/subscribe implementation, where you use custom enums as events.
Use static functions to publish/subscribe on events.
*/
class Eventer<T: Event> {
    /**
    Publish event
    
    :param: event Your event
    */
    class func publish(event: T) {
        publish(event, info: nil)
    }
    
    /**
    Publish event with info: AnyObject?
    
    :param: event Your event
    
    :param: info Any object you want to pass to actions
    */
    class func publish(event: T, info: AnyObject?) {
        for action in Eventer.sharedInstance.actions {
            if action.0 == event {
                action.1.execute(info)
            }
        }
    }
    
    /**
    Subscribe action to event
    
    :param: event Your event
    
    :param: action Function or closure without argument
    */
    class func subscribe(event: T, action: Action.SimpleAction) {
        Eventer.sharedInstance.actions.append((event, Action.Simple(action)))
    }
    
    /**
    Subscribe action to array of events
    
    :param: events Array of events
    
    :param: action Function or closure without argument
    */
    class func subscribe(events: [T], action: Action.SimpleAction) {
        let eventer = Eventer.sharedInstance
        for event in events {
            eventer.actions.append((event, Action.Simple(action)))
        }
    }
    
    /**
    Subscribe info action to event
    
    :param: event Your event
    
    :param: action Function or closure with info:AnyObject? argument
    */
    class func subscribe(event: T, action: Action.InfoAction) {
        Eventer.sharedInstance.actions.append((event, Action.Info(action)))
    }
    
    /**
    Subscribe info action to array of events
        
    :param: events Array of events
    
    :param: action Function or closure with info:AnyObject? argument
    */
    class func subscribe(events: [T], action: Action.InfoAction) {
        let eventer = Eventer.sharedInstance
        for event in events {
            eventer.actions.append((event, Action.Info(action)))
        }
    }
    
    /**
    Unsubscribe all actions from this event
    
    :param: event Your event
    */
    class func unsubscribe(event: T) {
        let eventer = Eventer.sharedInstance
        var index = 0
        for action in eventer.actions {
            if action.0 == event {
                eventer.actions.removeAtIndex(index)
            }
            index += 1
        }
    }
    
    static var sharedInstance:Eventer<T> {
        for eventerInstance in __eventerInstances {
            if let instance = eventerInstance as? Eventer<T> {
                return instance
            }
        }
        let eventer = Eventer<T>()
        __eventerInstances.append(eventer)
        return eventer
    }
    
    private var actions = [(T, Action)]()
}

/**
Do not change it! Internal variable for holding Eventer instances.
*/
var __eventerInstances = [AnyObject]()
