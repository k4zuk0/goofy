//
//  MenuHandler.swift
//  Goofy
//
//  Created by Daniel Büchele on 09/04/15.
//  Copyright (c) 2015 Daniel Büchele. All rights reserved.
//

import Foundation

class MenuHandler: NSObject {

    @IBAction func reload(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.startLoading()
        appDelegate.webView.reload()
    }
    
    @IBAction func newConversation(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.webView.evaluateJavaScript("newConversation()", completionHandler: nil);
    }
    
    @IBAction func gotoConversation(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.webView.evaluateJavaScript("gotoConversation("+String(sender.tag())+")", completionHandler: nil);
    }
    
    @IBAction func gotoConversationAtIndex(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.webView.evaluateJavaScript("gotoConversationAtIndex("+String(sender.tag())+")", completionHandler: nil);
    }
    
    @IBAction func logout(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.webView.evaluateJavaScript("logout()", completionHandler: nil);
        appDelegate.hideMenuBar()
    }
    
    @IBAction func plus(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.webView.evaluateJavaScript("plus()", completionHandler: nil);
    }
    
    @IBAction func info(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.webView.evaluateJavaScript("info()", completionHandler: nil);
    }
    
    @IBAction func search(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.webView.evaluateJavaScript("search()", completionHandler: nil);
    }
    
    @IBAction func preferences(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.webView.evaluateJavaScript("preferences()", completionHandler: nil);
    }
    
    @IBAction func fullscreen(sender: AnyObject) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window.toggleFullScreen(self)
    }
    
    @IBAction func handlePaste(sender: NSMenuItem) {
        let pasteboard = NSPasteboard.generalPasteboard()
        
        let classArray : Array<AnyClass> = [NSImage.self]
        let canReadData = pasteboard.canReadObjectForClasses(classArray, options: nil)
        
        if (canReadData) {
            var objectsToPaste = pasteboard.readObjectsForClasses(classArray, options: nil) as! Array<NSImage>
            let image = objectsToPaste[0];
            self.uploadimage(image)
        } else {
            // Forward any non-image pastes (text) to the webview as a standard paste event.
            NSApp.sendAction("paste:", to:nil, from:self)
        }
    }
    
    @IBAction func reportIssue(sender: NSMenuItem) {
        print("Nope!")
    }
    
    @IBAction func sendImage(sender: NSMenuItem?) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["png","jpg","jpeg","gif"]
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                let image = NSImage(contentsOfURL: openPanel.URL!);
                self.uploadimage(image!)
            }
        }
    }
    
    func uploadimage(image: NSImage) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        image.lockFocus();
        let bitmapRep = NSBitmapImageRep(focusedViewRect: NSMakeRect(0, 0, image.size.width, image.size.height));
        image.unlockFocus();
        let imageData = bitmapRep?.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: [:]);
        let base64String = imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed);
        //println(base64String!)
        appDelegate.webView.evaluateJavaScript("pasteImage('\(base64String!)')", completionHandler: nil);
    }
}


