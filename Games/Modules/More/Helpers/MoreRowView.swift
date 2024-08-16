//
//  MoreRowView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 09/01/2024.
//

import Foundation
import SwiftUI

struct MoreRowView: View {
    
    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.colorScheme) var colorScheme
    
    @State var imageName: String
    @State var text: String
    @State var subtitle: String?
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: self.imageName)
                .foregroundStyle(appTint)
                .imageScale(.large)
            
            VStack(alignment: .leading) {
                Text(self.text)
                    .font(.headline.bold())
                    .foregroundColor(.primary)
                
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .frame(height: 40)
    }
}
