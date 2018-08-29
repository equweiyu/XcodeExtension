//
//  SourceEditorCommand.swift
//  SortLine
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
            let start = selection.start.line
            let end = selection.end.line
            if let content = lines.subarray(with: NSRange(location: start, length: end+1-start)) as? [String] {
                let upContent =  content.sorted()
                for i in start...end {
                    lines.removeObject(at: i)
                    lines.insert(upContent[i-start], at: i)
                }
            }
        }
        completionHandler(nil)
    }
    
}
