//
//  ActionMaker.swift
//  BlocklyDemo
//
//  Created by cruzr on 2017/11/23.
//  Copyright © 2017年 martin. All rights reserved.
//

import Foundation
import JavaScriptCore


/**
 Protocol declaring all methods and properties that should be exposed to a JS context.
 */
@objc protocol ActionMakerJSExports: JSExport {
    static func setExpression(_ name: String)
    static func setAction(_ name: String)
    static func setText(_ text: String, _ delay : String)
    static func setTitle(_ title: String)
}

/**
 Class exposed to a JS context.
 */
@objcMembers class ActionMaker: NSObject, ActionMakerJSExports {
    static func setText(_ text: String, _ delay: String) {
        print("text = \(text), delay = \(delay)")
    }
    
    static func setTitle(_ title: String) {
        print("title = \(title)")
    }
 
    static func setExpression(_ name: String) {
        print("Expression = \(name)")
    }
    
    static func setAction(_ name: String) {
        print("Action = \(name)")
    }
}
