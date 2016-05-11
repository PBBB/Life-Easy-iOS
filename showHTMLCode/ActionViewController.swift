//
//  ActionViewController.swift
//  showHTMLCode
//
//  Created by PennIssac on 16/3/11.
//  Copyright © 2016年 PennIssac. All rights reserved.
//

import UIKit
import MobileCoreServices


class ActionViewController: UIViewController, UITextViewDelegate {
    
    var htmlTextView: UITextView!
    var textStorage: PBHighlightTextStorage!
    var highlighter: PBAttributedStringHighlighter!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHighlighter()
        createTextView()

        var htmlText = ""
        for item: AnyObject in self.extensionContext!.inputItems {
            let extItem = item as! NSExtensionItem
            let itemProvider = extItem.attachments!.first! as! NSItemProvider
            itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil) { results, error in
                guard results != nil else {
                    return
                }
                let dic = NSDictionary(object: results!, forKey: NSExtensionJavaScriptPreprocessingResultsKey)
                guard let extensionDic = dic[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {
                    return
                }
                guard let realExtensionDic = extensionDic[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {
                    return
                }
                if let headText = realExtensionDic.valueForKey("head") as? String, let bodyText = realExtensionDic.valueForKey("body") as? String {
                    htmlText = htmlText + "<head>\n" + headText + "</head>\n<body>\n" + bodyText + "\n</body>"
                    dispatch_async(dispatch_get_main_queue()){
                        self.title = realExtensionDic.valueForKey("title") as? String
                        self.highlighter.sourceString = htmlText
                        self.htmlTextView.attributedText = self.highlighter.highlightedString
                    }
                }
            }
        }


        
//        dispatch_async(dispatch_get_main_queue()){
//            //                    self.textView.text = "\(htmlText)"
//            //                    let htmlHighlightTextStorage = PBHighlightTextStorage(text: htmlText, hightRuleExpression: nil)
//            //                    htmlHighlightTextStorage.addLayoutManager(self.textView.layoutManager)
//            self.title = "fuck"
//        }
    }
    
//    override func viewDidLayoutSubviews() {
//        htmlTextView.frame = view.bounds
//    }
    func initializeHighlighter() {
        do {
            let HTMLTagregularExpression = try NSRegularExpression(pattern: "<\\w*[ >]", options: .CaseInsensitive)
            let HTMLTagEndregularExpression = try NSRegularExpression(pattern: "<\\/\\w*>", options: .CaseInsensitive)
            let HTMLTagColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
            let HTMLTagAttribute = [NSForegroundColorAttributeName : HTMLTagColor]
            highlighter = PBAttributedStringHighlighter(text: "", highlightRules: [HTMLTagregularExpression : HTMLTagAttribute, HTMLTagEndregularExpression : HTMLTagAttribute])
        } catch let error{
            highlighter = PBAttributedStringHighlighter()
            print(error)
        }
    }
    
    func createTextView() {
        htmlTextView = UITextView(frame: self.view.bounds) //使用默认UITextView
        htmlTextView.editable = false
        htmlTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//        为htmlTextView添加约束
//        let views = ["htmlTextView": htmlTextView]
//        let hFormatString = "|[htmlTextView]|"
//        let vFormatString = "V:|[htmlTextView]|"
//        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(hFormatString, options: .DirectionLeadingToTrailing, metrics: nil, views: views)
//        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(vFormatString, options: .DirectionLeadingToTrailing, metrics: nil, views: views)
//        NSLayoutConstraint.activateConstraints(hConstraints + vConstraints)
//        htmlTextView.delegate = self
        view.addSubview(htmlTextView)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        htmlTextView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }
    

}
