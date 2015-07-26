//
//  Async.swift
//  cloudplayer
//
//  Created by Стас on 23.09.14.
//  Copyright (c) 2014 Limehat. All rights reserved.
//

import UIKit


class dispatch
{
    class async
    {
        class func bg(block: dispatch_block_t) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block)
        }
        
        class func main(block: dispatch_block_t) {
            dispatch_async(dispatch_get_main_queue(), block)
        }
    }
    
    class sync
    {
        class func bg(block: dispatch_block_t) {
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block)
        }
        
        class func main(block: dispatch_block_t) {
            if NSThread.isMainThread()  {
                block()
            }
            else {
                dispatch_sync(dispatch_get_main_queue(), block)
            }
        }
    }
    
    class after {
        class func bg(when: Double, block: dispatch_block_t) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(when*Double(NSEC_PER_SEC))), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)!, block)
        }
        
        class func main(when: Double, block: dispatch_block_t) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(when*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
        }
    }
}
