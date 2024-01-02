//
//  SupportEmail.swift
//  GoodGames
//
//  Created by Ali Dinç on 10/01/2023.
//

import UIKit
import SwiftUI

struct SupportEmail {
    let toAddress: String
    let subject: String
    let messageHeader: String
    var data: Data?
    var body: String { """
Application Name: \(Bundle.main.appName)
iOS: \(UIDevice.current.systemVersion)
Device model: \(UIDevice.current.model)
App version: \(Bundle.main.appVersionLong)
App build: \(Bundle.main.appBuild)
\(messageHeader)
--------------------------------------------
"""
    }
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        openURL(url) { accepted in
            if !accepted {
                print(
"""
This device does not support email
\(body)
"""
                )
            }
        }
    }
}
