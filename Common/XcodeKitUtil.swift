//
//  XcodeKitUtil.swift
//  XcodeExtension
//
//  Created by 白天伟 on 2019/1/24.
//  Copyright © 2019 baitianwei. All rights reserved.
//

import Foundation
import XcodeKit

extension XCSourceEditorCommandInvocation {

    var selections: [XCSourceTextRange] {
        return buffer.selections as! [XCSourceTextRange]
    }

    func deleteEmptyLine() {
        selections.forEach { (selection) in
            let start = selection.startLine
            let end = selection.endLine
            let emptyLines = buffer.lines.subarray(with: NSRange(start...end)).filter({ (e) -> Bool in
                (e as! String).match(regular: "^\\s*$")
            })
            buffer.lines.removeObjects(in: emptyLines)
        }

    }
    func sortLine() {
        selections.forEach { (selection) in
            let start = selection.startLine
            let end = selection.endLine
            let sorted = buffer.lines.subarray(with: NSRange(start...end)).sorted(by: { (l, r) -> Bool in
                (l as! String) < (r as! String)
            })
            buffer.lines.replaceObjects(at: IndexSet(start...end), with: sorted)
        }

    }

    func convert(convert: (String) -> String) {
        selections.forEach { (selection) in
            let start = selection.startLine
            let end = selection.endLine
            (start...end).forEach({ (index) in
                let lineContent = buffer.lines[index] as! String
                var converted: String

                if start == end {
                    converted = lineContent[0..<selection.start.column] + convert(lineContent[selection.start.column..<selection.end.column]) + lineContent[selection.end.column...]
                } else if start == index {
                    converted = lineContent[0..<selection.start.column] + convert(lineContent[selection.start.column...])
                } else if end == index {
                    if selection.end.column == 0 {
                        converted = convert(lineContent)
                    } else {
                        converted = convert(lineContent[0..<selection.end.column]) + lineContent[selection.end.column...]
                    }
                } else {
                    converted = convert(lineContent)
                }
                buffer.lines.replaceObject(at: index, with: converted)
            })
        }
    }

    func convertFromSnake() {
        convert(convert: convertFromSnakeCase)
    }

}

extension XCSourceTextRange {
    var startLine: Int {
        return start.line
    }
    var endLine: Int {
        return end.line - (end.column == 0 ? 1 : 0)
    }
}
