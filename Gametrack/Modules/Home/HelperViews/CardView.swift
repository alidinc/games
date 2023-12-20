//
//  CardView.swift
//  Cards
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

struct CardView: View {
    
    var game: Game
    @Binding var screenSize: CGSize
    @State var isTapped = false
    
    var body: some View {
        AsyncImageView(with: game.cover?.url ?? "", type: .infinity)
            .aspectRatio(contentMode: .fill)
            .frame(height: isTapped ? screenSize.height - 200 : 500)
            .frame(width: isTapped ? screenSize.width : screenSize.width - 40)
            .cornerRadius(20)
            .overlay(alignment: .bottom) {
                CardContent
            }
            .offset(y: isTapped ? -100 : 0)
            .dynamicTypeSize(.xSmall ... .xLarge)
            .frame(maxWidth: screenSize.width, maxHeight: .infinity)
            .padding(.vertical, 10)
            .animation(.bouncy, value: isTapped)
            .onTapGesture {
                isTapped.toggle()
            }
    }
    
    var CardContent: some View {
        ZStack(alignment: .bottom) {
            
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(linearGradient)
                .opacity(isTapped ? 0 : 1)
            
            VStack(alignment: .leading) {
                Text(game.name ?? "")
                    .font(isTapped ? .title : .title2)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .shadow(color: .black, radius: 10, y: 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                RatingStatusView(game: game)
            }
            .padding(.horizontal)
            .padding(.vertical, 40)
            .background (
                LinearGradient(colors: [.clear, .black.opacity(0.85)], 
                               startPoint: .top, 
                               endPoint: .center),
                in: .rect(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
            )
        }
    }
    
    var linearGradient: LinearGradient {
        LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
    }
}
