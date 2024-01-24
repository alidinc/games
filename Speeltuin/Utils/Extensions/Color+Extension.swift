//
//  Color+Extension.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import Foundation
import SwiftUI
import UIKit

extension Color: RawRepresentable {
    
    public init?(rawValue: String) {
        
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? .black
            self = Color(color)
        } catch {
            self = .black
        }
        
    }
    
    public var rawValue: String {
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
            
        }catch{
            
            return ""
            
        }
        
    }
    
}

extension Color {
    static var randomColor: Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        
        return Color(red: red, green: green, blue: blue)
    }
    
    static var randomDarkColor: Color {
        let red = Double.random(in: 0...0.5)
        let green = Double.random(in: 0...0.5)
        let blue = Double.random(in: 0...0.5)
        
        return Color(red: red, green: green, blue: blue)
    }
    
    static func gradientBackground() -> some View {
        let startColor = Color.randomColor
        let endColor = Color.randomColor
        
        return LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .leading, endPoint: .trailing)
    }
}
