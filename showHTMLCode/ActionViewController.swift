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
        //textView.setHighlightDefinitionWithContentsOfFile(NSBundle.mainBundle().pathForResource("html", ofType: "plist", inDirectory: "Syntax Definitions"))
        // Get the item[s] we're handling from the extension context.
        self.automaticallyAdjustsScrollViewInsets = false
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        for item: AnyObject in self.extensionContext!.inputItems {
            let extItem = item as! NSExtensionItem
            let itemProvider = extItem.attachments!.first! as! NSItemProvider
            itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil) {
                results, error in
//                let result = NSDictionary(coder: results)
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
                    self.textView.text = "\(htmlText)"
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
    
//    override func beginRequestWithExtensionContext(context: NSExtensionContext) {
//        super.beginRequestWithExtensionContext(context)
//        for item: AnyObject in context.inputItems {
//            let extItem = item as! NSExtensionItem
//            let itemProvider = extItem.attachments!.first! as! NSItemProvider
//            itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil) {
//                results, error in
//                //                let result = NSDictionary(coder: results)
//                dispatch_async(dispatch_get_main_queue()){
//                    self.textView.text = "\(results)"
//                }
//            }
//        }
//    }

}
