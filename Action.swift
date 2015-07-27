//  Created by Stanislav Feldman on 27/07/15.
//  Copyright (c) 2015 Stanislav Feldman. All rights reserved.

/**
Action holder. Holds action with or without info parameter.
Executes action immediate by default or in background or main thread.
*/
enum Action {
    typealias SimpleAction = () -> Void
    typealias InfoAction = (info: AnyObject?) -> Void
    typealias NotificationAction = (notification: NSNotification!) -> Void
    
    case Simple(SimpleAction)
    case Info(InfoAction)
    
    enum Execution {
        case Immediate
        case Background
        case Main
    }
    
    func execute(execution:Execution = .Immediate) {
        execute(nil, execution: execution)
    }
    
    func execute(info: AnyObject?, execution:Execution = .Immediate) {
        switch self {
        case .Simple(let action):
            switch execution {
            case .Background:
                dispatch.async.bg {
                    action()
                }
            case .Main:
                dispatch.async.main {
                    action()
                }
            default:
                action()
            }
        case .Info(let action):
            switch execution {
            case .Background:
                dispatch.async.bg {
                    action(info: info)
                }
            case .Main:
                dispatch.async.main {
                    action(info: info)
                }
            default:
                action(info: info)
            }
        default:
            break
        }
    }
}
