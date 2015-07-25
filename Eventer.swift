//
//  SEV.swift
//  whereabout
//
//  Created by Stanislav Feldman on 26/07/15.
//  Copyright (c) 2015 Limehat. All rights reserved.
//

// inherit your Events enum from this protocol
protocol Event: Hashable {}


class Eventer<T: Event> {
    typealias Action = (info: AnyObject?) -> Void
    
    class func publish(event: T, info: AnyObject?=nil) {
        for action in Eventer.sharedInstance.actions {
            if action.0 == event {
                action.1(info:info)
            }
        }
    }
    
    class func subscribe(event: T, action: Action) {
        Eventer.sharedInstance.actions.append((event, action))
    }
    
    class func subscribe(events: [T], action: Action) {
        let eventer = Eventer.sharedInstance
        for event in events {
            eventer.actions.append((event, action))
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
