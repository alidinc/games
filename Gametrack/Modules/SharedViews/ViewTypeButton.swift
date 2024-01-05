//
//  ViewTypeButton.swift
//  Gametrack
//
//  Created by Ali Dinç on 31/12/2023.
//

import SwiftUI

struct ViewTypeButton: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    @Binding var viewType: ViewType
    
    var body: some View {
        Menu {
            Section("View type") {
                Button {
                    DispatchQueue.main.async {
                        viewType = .list
                    }
                } label: {
                    Image(systemName: "rectangle.grid.1x2.fill")
                    Text("List")
                }
                
                Button {
                    DispatchQueue.main.async {
                        viewType = .list
                    }
                } label: {
                    Image(systemName: "rectangle.grid.3x2.fill")
                    Text("Grid")
                }
            }
            
        } label: {
            SFImage(name: viewType.imageName, color: appTint)
        } primaryAction: {
            DispatchQueue.main.async {
                viewType = viewType == .grid ? .list : .grid
            }
        }
    }
}
