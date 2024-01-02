//
//  SearchTextField.swift
//  Gametrack
//
//  Created by Ali Dinç on 31/12/2023.
//

import SwiftUI

struct SearchTextField: View {
    
    @Binding var searchQuery: String
    @AppStorage("appTint") var appTint: Color = .white
    
    var body: some View {
        HStack(spacing: 0) {
            TextField("", text: $searchQuery)
                .frame(height: 24, alignment: .leading)
                .padding(10)
                .background(.ultraThinMaterial, in: .rect(topLeadingRadius: 8, bottomLeadingRadius: 8))
                .autocorrectionDisabled()
                .overlay {
                    if !searchQuery.isEmpty {
                        HStack {
                            Spacer()
                            Button {
                                searchQuery = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                            }
                            .foregroundColor(.secondary)
                        }
                        .padding(.trailing, 6)
                    }
                }
            
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(appTint)
                .aspectRatio(contentMode: .fit)
                .padding(10)
                .background(
                    .ultraThinMaterial,
                    in: .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 8,
                        topTrailingRadius: 8
                    )
                )
        }
    }
}
