//
//  ViewTypeButton.swift
//  Gametrack
//
//  Created by Ali Dinç on 31/12/2023.
//

import SwiftUI

struct ViewTypeButton: View {
    
    @AppStorage("collectionViewType") private var viewType: ViewType = .list
    
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
                        viewType = .grid
                    }
                } label: {
                    Image(systemName: "rectangle.grid.3x2.fill")
                    Text("Grid")
                }
                
                Button {
                    DispatchQueue.main.async {
                        viewType = .card
                    }
                } label: {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                    Text("Card")
                }
            }
            
        } label: {
            SFImage(name: viewType.imageName)
        } primaryAction: {
            DispatchQueue.main.async {
                withAnimation(.snappy) {
                    if viewType == .list {
                        viewType = .grid
                    } else if viewType == .grid {
                        viewType = .card
                    } else if viewType == .card {
                        viewType = .list
                    }
                }
            }
        }
    }
}

#Preview {
    ViewTypeButton()
}
