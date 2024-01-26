//
//  PickerHeaderView.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import SwiftUI

struct PickerHeaderView: View {
    
    @AppStorage("appTint") var appTint: Color = .blue
    
    var title: String
    var imageName: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            HStack {
                Image(systemName: imageName)
                    .foregroundStyle(appTint)
                
                Text(title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.primary)
                    .shadow(radius: 10)
            }
            
            Image(systemName: "chevron.down")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(appTint)
        }
        .hSpacing(.leading)
    }
}
