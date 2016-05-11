//
//  PBAttributedStringHighlighter.swift
//  LifeEasy
//
//  Created by PBB on 16/5/11.
//  Copyright © 2016年 PennIssac. All rights reserved.
//

import Foundation

class PBAttributedStringHighlighter {
    
    var sourceString: String
    var highlightRules: [NSRegularExpression : [String : AnyObject]]?
    var highlightedString: NSAttributedString {
        get {
            return self.calculateHighlightedString()
        }
    }
    
    //自定义初始化方法
    init(text: String, highlightRules: [NSRegularExpression : [String : AnyObject]]?) {
        self.sourceString = ""
        self.highlightRules = highlightRules
    }
    
    convenience init() {
        self.init(text: "", highlightRules: nil)
    }
    
    private func calculateHighlightedString() -> NSAttributedString {
        let resultAttributedString = NSMutableAttributedString(string: sourceString)
        if self.highlightRules == nil {
            print("no highlightRules")
            return resultAttributedString
        }
        
        for (regex, attribute) in self.highlightRules! {
            regex.enumerateMatchesInString(self.sourceString, options: .WithTransparentBounds, range: NSRange(location: 0, length: (sourceString as NSString).length)) { (result, flags, stop) in
                if let range = result?.range {
                    resultAttributedString.addAttributes(attribute, range: range)
                }
            }
        }
        return resultAttributedString
    }
}