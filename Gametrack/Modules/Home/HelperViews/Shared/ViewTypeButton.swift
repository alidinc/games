//
//  ViewTypeButton.swift
//  Gametrack
//
//  Created by Ali Dinç on 31/12/2023.
//

import SwiftUI

struct ViewTypeButton: View {
    
    @AppStorage("collectionViewType") private var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .white
    
    var body: some View {
        Menu {
            Section("View type") {
                Button {
                    viewType = .list
                } label: {
                    Image(systemName: "rectangle.grid.1x2.fill")
                    Text("List")
                }
                
                Button {
                    viewType = .grid
                } label: {
                    Image(systemName: "rectangle.grid.3x2.fill")
                    Text("Grid")
                }
            }
            
        } label: {
            SFImage(name: viewType.imageName, color: appTint)
        } primaryAction: {
            viewType = viewType == .list ? .grid : .list
        }
    }
}

#Preview {
    ViewTypeButton()
}
