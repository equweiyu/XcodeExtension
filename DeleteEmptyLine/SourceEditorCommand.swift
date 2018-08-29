//
//  SourceEditorCommand.swift
//  DeleteEmptyLine
//
//  Created by 白天伟 on 2018/8/28.
//  Copyright © 2018年 baitianwei. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        let lines = invocation.buffer.lines
        if let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange {
            (selection.start.line...selection.end.line)
                .filter { (i) -> Bool in
                    if let l = lines[i] as? String, l.range(of: "^\\s*$", options: .regularExpression, range: nil, locale: nil) != nil {
                        return true
                    }else {
                        return false
                    }
                }
                .sorted(by: {$0 > $1})
                .forEach({lines.removeObject(at: $0)})
        }
        completionHandler(nil)
    }
    
}
