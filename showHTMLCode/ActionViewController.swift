//
//  ActionViewController.swift
//  showHTMLCode
//
//  Created by PennIssac on 16/3/11.
//  Copyright © 2016年 PennIssac. All rights reserved.
//

import UIKit
import MobileCoreServices


class ActionViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

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
                    let htmlHighlightTextStorage = PBHighlightTextStorage(text: htmlText, hightRuleExpression: nil)
                    htmlHighlightTextStorage.addLayoutManager(self.textView.layoutManager)
                    self.title = realExtensionDic.valueForKey("title") as? String
                }
            }
        }
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
