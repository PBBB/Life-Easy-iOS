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
    var _highlightRuleExpression: NSRegularExpression?
    
    //自定义初始化方法
    init(text: String, highlightRuleExpression: NSRegularExpression?) {
        self._attributedString = NSMutableAttributedString(string: text)
        self._highlightRuleExpression = highlightRuleExpression
        super.init()
    }
    
    convenience override init() {
        self.init(text: "Something went wrong. Please try again.", highlightRuleExpression: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("init with coder")
        if let text = aDecoder.decodeObjectForKey("_attributedString") as? NSMutableAttributedString {
            self._attributedString = text
        } else {
            self._attributedString = NSMutableAttributedString()
        }
        
        if let expression = aDecoder.decodeObjectForKey("_highlightRuleExpression") as? NSRegularExpression {
            self._highlightRuleExpression = expression
        }
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        print("encode with coder")
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_attributedString, forKey: "_attributedString")
        aCoder.encodeObject(_highlightRuleExpression, forKey: "_highlightRuleExpression")
    }
    
    
    
    //继承所需要重载的四个属性/方法
    override var string: String {
        return _attributedString.string
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return _attributedString.attributesAtIndex(location, effectiveRange: range)
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        beginEditing()
        _attributedString.replaceCharactersInRange(range, withString: str)
        self.edited(.EditedCharacters, range: range,
                    changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        beginEditing()
        _attributedString.setAttributes(attrs, range: range)
        self.edited(.EditedCharacters, range: range, changeInLength: 0)
        endEditing()
    }
    
    //处理高亮
    override func processEditing() {
        print("processEditing")
    }
}
