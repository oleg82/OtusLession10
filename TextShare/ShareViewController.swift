//
//  ShareViewController.swift
//  TextShare
//
//  Created by Олег Иванов on 27/08/2019.
//  Copyright © 2019 Otus. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        guard let text = textView.text else {return}

        if let ud = UserDefaults(suiteName: "group.otus.sharetext") {
            ud.set(text, forKey: "text")
        }
        if let url = URL(string: "OtusLession10ShareText://text") {
            _ = openURL(url)
        }
        
        dismiss(animated: false) {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let app = responder as? UIApplication {
                return app.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
