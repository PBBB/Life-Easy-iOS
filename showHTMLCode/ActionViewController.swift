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

    override func viewDidLoad() {
        super.viewDidLoad()
        createTextView()
//        self.automaticallyAdjustsScrollViewInsets = false
        
        //initiate NSTextStorage, NSLayoutManager, NSTextContainer and UITextView
//        let htmlHighlightTextStorage = PBHighlightTextStorage()
//        let layoutManager = NSLayoutManager()
//        htmlHighlightTextStorage.addLayoutManager(layoutManager)
//        
//        let textContainer = NSTextContainer()
//        layoutManager.addTextContainer(textContainer)
//        
//        htmlTextView = UITextView(frame: CGRectZero, textContainer: textContainer)
////        htmlTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//        htmlTextView.translatesAutoresizingMaskIntoConstraints = false
////        htmlTextView.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
//        
//        self.view.addSubview(htmlTextView)
//        
////        为htmlTextView添加约束
//        let views = ["htmlTextView": htmlTextView]
//        let hFormatString = "|[htmlTextView]|"
//        let vFormatString = "V:|[htmlTextView]|"
//        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(hFormatString, options: .DirectionLeadingToTrailing, metrics: nil, views: views)
//        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(vFormatString, options: .DirectionLeadingToTrailing, metrics: nil, views: views)
//        NSLayoutConstraint.activateConstraints(hConstraints + vConstraints)
//        

        for item: AnyObject in self.extensionContext!.inputItems {
            let extItem = item as! NSExtensionItem
            let itemProvider = extItem.attachments!.first! as! NSItemProvider
            itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil) {
                results, error in
                guard results != nil else {
                    return
                }
                let dic = NSDictionary(object: results!, forKey: NSExtensionJavaScriptPreprocessingResultsKey)
                var htmlText = ""
                guard let extensionDic = dic[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {
                    return
                }
                guard let realExtensionDic = extensionDic[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {
                    return
                }
                if let headText = realExtensionDic.valueForKey("head") as? String, let bodyText = realExtensionDic.valueForKey("body") as? String {
                    htmlText = htmlText + "<head>\n" + headText + "</head>\n<body>\n" + bodyText + "\n</body>"
                }
                
                dispatch_async(dispatch_get_main_queue()){
//                    self.textView.text = "\(htmlText)"
//                    let htmlHighlightTextStorage = PBHighlightTextStorage(text: htmlText, hightRuleExpression: nil)
//                    htmlHighlightTextStorage.addLayoutManager(self.textView.layoutManager)
                    self.textStorage.appendAttributedString(NSMutableAttributedString(string: htmlText, attributes: [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]))
                    self.title = realExtensionDic.valueForKey("title") as? String
                }
            }
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        htmlTextView.frame = view.bounds
//    }
    
    func createTextView() {
        let attrs = [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        let attrString = NSAttributedString(string: "Some initial text.", attributes: attrs)
        textStorage = PBHighlightTextStorage()
        textStorage.appendAttributedString(attrString)
        
        let newTextViewRect = view.bounds
        
        let layoutManager = NSLayoutManager()
        
        let containerSize = CGSize(width: newTextViewRect.width, height: CGFloat.max)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        htmlTextView = UITextView(frame: newTextViewRect, textContainer: container)
        htmlTextView.delegate = self
        view.addSubview(htmlTextView)
        
    }
    
    override func viewDidLayoutSubviews() {
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
