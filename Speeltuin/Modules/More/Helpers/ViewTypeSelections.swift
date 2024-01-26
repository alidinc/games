//
//  ViewTypeSelections.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import SwiftUI

struct ViewTypeSelections: View {
    
    @AppStorage("viewType") private var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                MoreHeaderTextView(title: "View type", subtitle: "Select a style you like.")
                Spacer()
                CloseButton { self.dismiss() }
            }
            .padding(.bottom, 20)
            
            ScrollView {
                VStack {
                    ForEach(ViewType.allCases, id: \.id) { type in
                        Button {
                            self.viewType = type
                            dismiss()
                        } label: {
                            MoreRowView(imageName: type.imageName, text: type.rawValue.capitalized)
                                .padding(16)
                                .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
                                .overlay {
                                    if viewType == type {
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(appTint, lineWidth: 2)
                                    }
                                }
                        }
                    }
                }
            }
        }
        .padding()
    }
}
