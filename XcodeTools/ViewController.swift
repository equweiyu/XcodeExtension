//
//  ViewController.swift
//  XcodeTools
//
//  Created by 白天伟 on 2019/4/25.
//  Copyright © 2019 bai. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var inputTextView: NSTextView!
    @IBOutlet weak var outputTextView: NSTextView!
    
    @IBAction func convert(_ sender: NSButton) {
        
        do {
            if let json = try inputTextView.string.data(using: String.Encoding.utf8)?.JSONObject() {
                outputTextView.string =
                """
                // let jsonDecoder = JSONDecoder()
                // jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                // let model = try? jsonDecoder.decode(DefaultClass.self, from: jsonData)
                
                \(covertToObjectModel(key: "DefaultClass", json: json)?.show() ?? "")
                """
            } else {
                outputTextView.string = inputTextView.string
            }
        } catch (let error) {
            outputTextView.string = error.localizedDescription
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputTextView.font = NSFont(name: "Monaco", size: 14)
        outputTextView.isAutomaticQuoteSubstitutionEnabled = false
        inputTextView.isAutomaticQuoteSubstitutionEnabled = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

