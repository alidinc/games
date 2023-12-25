//
//  SummaryView.swift
//  Gametrack
//
//  Created by Ali Dinç on 25/12/2023.
//

import SwiftUI

struct SummaryView: View {
    
    var game: Game
    @State private var showMore = false
    
    var body: some View {
        if let summary = game.summary {
            Group {
                Text("\(showMore ? summary : String(summary.prefix(200)))")
                    .foregroundStyle(.primary)
                   
              +   Text(showMore || (summary.count < 150) ? "" : " ... more")
                    .foregroundStyle(.blue)
            }
            .font(.subheadline)
            .padding(.horizontal)
            .onTapGesture {
                withAnimation {
                    showMore.toggle()
                }
            }
            
        }
    }
}
