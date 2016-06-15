//
//  PBHighlightTextStorage.swift
//  LifeEasy
//
//  Created by PennIssac on 16/4/3.
//  Copyright © 2016年 PennIssac. All rights reserved.
//

import UIKit

class PBHighlightTextStorage: NSTextStorage {
    var _attributedString: NSMutableAttributedString
    var _highlightRules: [RegularExpression : [String : AnyObject]]?
    
    //自定义初始化方法
    init(text: String, highlightRules: [RegularExpression : [String : AnyObject]]?) {
        self._attributedString = NSMutableAttributedString(string: text)
        self._highlightRules = highlightRules
        super.init()
    }
    
    convenience override init() {
        self.init(text: "", highlightRules: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("init with coder")
        if let text = aDecoder.decodeObject(forKey: "_attributedString") as? NSMutableAttributedString {
            self._attributedString = text
        } else {
            self._attributedString = NSMutableAttributedString()
        }
        
        if let rules = aDecoder.decodeObject(forKey: "_highlightRules") as? [RegularExpression : [String : AnyObject]] {
            self._highlightRules = rules
        }
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        print("encode with coder")
        super.encode(with: aCoder)
        aCoder.encode(_attributedString, forKey: "_attributedString")
        aCoder.encode(_highlightRules, forKey: "_highlightRules")
    }
    
    
    
    //继承所需要重载的四个属性/方法
    override var string: String {
        return _attributedString.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : AnyObject] {
        return _attributedString.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        _attributedString.replaceCharacters(in: range, with: str)
        self.edited(.editedCharacters, range: range,
                    changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [String : AnyObject]?, range: NSRange) {
        beginEditing()
        _attributedString.setAttributes(attrs, range: range)
        self.edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    //处理高亮
//    override func processEditing() {
//        self.performHighlightingForRange(self.editedRange)
//        super.processEditing()
//    }
//    
//    func performHighlightingForRange(changedRange: NSRange) {
//        if self._highlightRules == nil {
//            print("_highlightRules nil")
//            return
//        }
//        for (regex, attribute) in self._highlightRules! {
//            regex.enumerateMatchesInString(self._attributedString.string, options: .WithTransparentBounds, range: changedRange) { (result, flags, stop) in
//                if let range = result?.range {
//                    self._attributedString.addAttributes(attribute, range: range)
//                }
//            }
//        }
//    }
}
