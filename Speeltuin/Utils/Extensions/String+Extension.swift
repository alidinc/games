//
//  String+Extension.swift
//  Speeltuin
//
//  Created by Ali Dinç on 09/01/2024.
//

import Foundation

extension String {
    func strippingHTML() -> String?  {
        if isEmpty {
            return nil
        }
        
        if let data = data(using: .utf8) {
            do {
                let attributedString = try NSAttributedString(data: data,
                                                              options: [.documentType : NSAttributedString.DocumentType.html,
                                                                        .characterEncoding: String.Encoding.utf8.rawValue],
                                                              documentAttributes: nil)
                
                
                var string = attributedString.string
               
                // These steps are optional, and it depends on how you want handle whitespace and newlines
                string = string.replacingOccurrences(of: "\u{FFFC}",
                                                     with: "",
                                                     options: .regularExpression,
                                                     range: nil)
                string = string.replacingOccurrences(of: "(\n){3,}",
                                                     with: "\n\n",
                                                     options: .regularExpression,
                                                     range: nil)
                return string.trimmingCharacters(in: .whitespacesAndNewlines)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
}

extension String {
    func htmlToString() -> String? {
        do {
                // Define the regular expression pattern to match HTML tags
                let regex = try NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive)
                
                // Replace HTML tags with an empty string
                let range = NSRange(location: 0, length: self.utf16.count)
                let plainTextString = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
                
                return plainTextString
            } catch {
                print("Error creating regular expression: \(error)")
                return self // Return original string if there's an error
            }
    }
}
