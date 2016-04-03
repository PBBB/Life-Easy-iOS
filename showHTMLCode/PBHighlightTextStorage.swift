//
//  PBHighlightTextStorage.swift
//  LifeEasy
//
//  Created by PennIssac on 16/4/3.
//  Copyright © 2016年 PennIssac. All rights reserved.
//

import UIKit

class PBHighlightTextStorage: NSTextStorage {
    var _attributedString: NSAttributedString
    var _hightRuleExpression: NSRegularExpression?
    
    //自定义初始化方法
    init(text: String, hightRuleExpression: NSRegularExpression?) {
        self._attributedString = NSAttributedString(string: text)
        self._hightRuleExpression = hightRuleExpression
        super.init()
    }
    
    convenience override init() {
        self.init(text: "", hightRuleExpression: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let text = aDecoder.decodeObjectForKey("_attributedString") as? NSAttributedString {
            self._attributedString = text
        } else {
            self._attributedString = NSAttributedString()
        }
        
        if let expression = aDecoder.decodeObjectForKey("_hightRuleExpression") as? NSRegularExpression {
            self._hightRuleExpression = expression
        }
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(_attributedString, forKey: "_attributedString")
        aCoder.encodeObject(_hightRuleExpression, forKey: "_hightRuleExpression")
    }
    
    
    
    //继承所需要重载的四个属性/方法
    override var string: String {
        return _attributedString.string
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return[:]
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        
    }
    
    //处理高亮
    override func processEditing() {
        print("processEditing")
    }
}
