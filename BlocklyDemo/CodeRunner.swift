//
//  CodeRunner.swift
//  BlocklyDemo
//
//  Created by cruzr on 2017/11/23.
//  Copyright © 2017年 martin. All rights reserved.
//

import JavaScriptCore


/**
 Runs JavaScript code.
 */
class CodeRunner {
    /// Use a JSContext object, which contains a JavaScript virtual machine.
    private var context: JSContext?
    
    /// Create a background thread, so the main thread isn't blocked when executing
    /// JS code.
    private let jsThread = DispatchQueue(label: "jsContext")
    
    init() {
        // Initialize the JSContext object on the background thread since that's where
        // code execution will occur.
        jsThread.async {
            self.context = JSContext()
            self.context?.exceptionHandler = { context, exception in
                let error = exception?.description ?? "unknown error"
                print("JS Error: \(error)")
            }
            
            // Register ActionMaker class with the JSContext object. This tells JSContext to
            // route any JavaScript calls to `ActionMaker` back to iOS code.
            self.context?.setObject(
                ActionMaker.self, forKeyedSubscript: "ActionMaker" as NSString)
        }
    }
    
    /**
     Runs Javascript code on a background thread.
     
     - parameter code: The Javascript code.
     - parameter completion: Closure that is called on the main thread when
     the code has finished executing.
     */
    func runJavascriptCode(_ code: String, completion: @escaping () -> ()) {
        jsThread.async {
            // Evaluate the JavaScript code asynchronously on the background thread.
            _ = self.context?.evaluateScript(code)
            
            // When it finishes, call the completion closure on the main thread.
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

