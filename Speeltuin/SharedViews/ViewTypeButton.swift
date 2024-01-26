//
//  ViewTypeButton.swift
//  Speeltuin
//
//  Created by Ali Dinç on 31/12/2023.
//

import SwiftUI

struct ViewTypeButton: View {
    
    @AppStorage("appTint") var appTint: Color =  .blue
    @AppStorage("viewType") var viewType: ViewType = .list
    
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
            SFImage(name: viewType.imageName, config: .init(padding: 6, color: appTint))
        } primaryAction: {
            viewType = viewType == .grid ? .list : .grid
        }
    }
}
