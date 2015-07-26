//
//  SEV.swift
//  whereabout
//
//  Created by Stanislav Feldman on 26/07/15.
//  Copyright (c) 2015 Limehat. All rights reserved.
//

// inherit your Events enum from this protocol
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


class Eventer<T: Event> {
    class func publish(event: T) {
        publish(event, info: nil)
    }
    
    class func publish(event: T, info: AnyObject?) {
        for action in Eventer.sharedInstance.actions {
            if action.0 == event {
                action.1.execute(info)
            }
        }
    }
    
    class func subscribe(event: T, action: Action.SimpleAction) {
        Eventer.sharedInstance.actions.append((event, Action.Simple(action)))
    }
    
    class func subscribe(events: [T], action: Action.SimpleAction) {
        let eventer = Eventer.sharedInstance
        for event in events {
            eventer.actions.append((event, Action.Simple(action)))
        }
    }
    
    class func subscribe(event: T, action: Action.InfoAction) {
        Eventer.sharedInstance.actions.append((event, Action.Info(action)))
    }
    
    class func subscribe(events: [T], action: Action.InfoAction) {
        let eventer = Eventer.sharedInstance
        for event in events {
            eventer.actions.append((event, Action.Info(action)))
        }
    }
    
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
            if eventerInstance is Eventer<T> {
                return eventerInstance as! Eventer<T>
            }
        }
        let eventer = Eventer<T>()
        __eventerInstances.append(eventer)
        return eventer
    }
    
    private var actions = [(T, Action)]()
}
var __eventerInstances = [AnyObject]()
