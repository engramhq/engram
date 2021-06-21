//
//  ShareViewController.swift
//  Send to engram
//
//  Created by Adam Berg on 2021-06-21.
//

import UIKit
import Social
import SwiftKeychainWrapper

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        
        
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        print(contentText!)
        loginAndAddNote(body: contentText!)
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}

func loginAndAddNote(body: String) {
    let url = URL(string: "https://engram.xyzdigital.com/api/users/login")!
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    
    let uniqueServiceName = "com.xyzdigital.engram"
    let uniqueAccessGroup = "group.engram"
    
    let customKeychainWrapperInstance = KeychainWrapper(serviceName: uniqueServiceName, accessGroup: uniqueAccessGroup)
    
    let email = customKeychainWrapperInstance.string(forKey: "email") ?? ""
    let password = customKeychainWrapperInstance.string(forKey: "password") ?? ""
    
    print(email)
    
    let bodyData = try? JSONSerialization.data(
        withJSONObject: ["username": email, "password": password],
        options: []
    )

    request.httpMethod = "POST"
    request.httpBody = bodyData
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in

        if let error = error {
            print(error)
        } else if let data = data {
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    addNote(body: body)
                }
            }
            
        } else {
            // Handle unexpected error
        }
    }
    task.resume()
}

func addNote(body: String) {
    let url = URL(string: "https://engram.xyzdigital.com/api/notes")!
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd";
    let dateString = dateFormatter.string(from: Date())
    
    let bodyData = try? JSONSerialization.data(
        withJSONObject: ["body": body, "date": dateString, "type": "note"],
        options: []
    )

    request.httpMethod = "POST"
    request.httpBody = bodyData
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in

        if let error = error {
            print(error)
        } else if data != nil {
            print("success")
        } else {
            // Handle unexpected error
            print("unexpected")
        }
    }
    task.resume()
}
