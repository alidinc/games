//
//  MoreHeaderView.swift
//  Speeltuin
//
//  Created by alidinc on 29/01/2024.
//

import Foundation
import SwiftUI

struct MoreHeaderTextView: View {
    
    var title: String
    var subtitle: String?
    
    var body: some View {
        VStack {
            Text(self.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .hSpacing(.leading)
            
            
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .hSpacing(.leading)
            }
        }
    }
}
