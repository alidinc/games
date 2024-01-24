//
//  PickerHeaderView.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import SwiftUI

struct PickerHeaderView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    
    var title: String
    var imageName: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            HStack {
                SFImage(
                    name: imageName,
                    config: .init(
                        opacity: 0,
                        radius: 0,
                        padding: 0,
                        color: appTint
                    )
                )
                
                Text(title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.primary)
                    .shadow(radius: 10)
            }
            
            SFImage(
                name: "chevron.down",
                config: .init(
                    opacity: 0,
                    padding: 0,
                    color: appTint,
                    iconSize: 20,
                    isBold: true
                )
            )
        }
        .hSpacing(.leading)
    }
}
