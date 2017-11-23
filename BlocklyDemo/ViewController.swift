//
//  ViewController.swift
//  BlocklyDemo
//
//  Created by cruzr on 2017/11/22.
//  Copyright © 2017年 martin. All rights reserved.
//

import UIKit
import Blockly

class ViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    
    private var codeManager = CodeManager()
    
    let workbenchViewController = WorkbenchViewController(style: .alternate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        // Load its block factory with default blocks
        let blockFactory = workbenchViewController.blockFactory
        blockFactory.load(fromDefaultFiles: .allDefault)
        
        do {
            try blockFactory.load(fromJSONPaths: ["custom_blocks.json"])
        } catch let error {
            print("An error occurred loading the sound blocks: \(error)")
        }
        
        // Load toolbox
        do {
            let toolboxPath = "toolbox.xml"
            if let bundlePath = Bundle.main.path(forResource: toolboxPath, ofType: nil) {
                let xmlString = try String(contentsOfFile: bundlePath, encoding: String.Encoding.utf8)
                let toolbox = try Toolbox.makeToolbox(xmlString: xmlString, factory: blockFactory)
                try workbenchViewController.loadToolbox(toolbox)
            } else {
                print("Could not load toolbox XML from '\(toolboxPath)'")
            }
        } catch let error {
            print("An error occurred loading the toolbox: \(error)")
        }
        
        // Add editor to this view controller
        addChildViewController(workbenchViewController)
        view.addSubview(workbenchViewController.view)
        workbenchViewController.view.frame = view.bounds
        workbenchViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        workbenchViewController.didMove(toParentViewController: self)
        
        
        self.view.bringSubview(toFront: saveBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveBtnClicked(_ sender: UIButton) {
        print("saveBtnClicked")
        // Save the workspace to disk
        if let workspace = workbenchViewController.workspace {
            do {
                let xml = try workspace.toXML()
                FileHelper.saveContents(xml, to: "workspace.xml")
                
                generateCode()
                
                
            } catch let error {
                print("Couldn't save workspace to disk: \(error)")
            }
        }
    }
    
    func generateCode() {
        // If a saved workspace file exists for this button, generate the code for it.
        if let workspaceXML = FileHelper.loadContents(of: "workspace.xml") {
            codeManager.generateCode(workspaceXML: workspaceXML, savedCode: { code in
                print("Code for button :\n \(code)")
                
                let codeRunner = CodeRunner()
                codeRunner.runJavascriptCode(code, completion: {
                    print("code runned")
                })
            })
        }
    }
    
    func runCode() {
        let code = codeManager.code() ?? "Unavailable"
        print("Code for button :\n \(code)")
    }
    
}

