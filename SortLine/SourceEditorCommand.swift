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

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        defer { completionHandler(nil) }
        invocation.sortLine()
    }

}
