//
//  RatingStarsView.swift
//  Gametrack
//
//  Created by Ali Dinç on 22/12/2023.
//

import SwiftUI

struct RatingStarsView: View {
    
    @State var rating: Int
    
    var label = ""
    var maxRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.orange
    
    var body: some View {
        HStack(spacing: 0) {
            if self.label.isEmpty == false {
                Text(self.label)
            }
            
            ForEach(1..<self.maxRating + 1, id: \.self) { number in
                self.image(for: number)
                    .font(.system(size: 12))
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor.opacity(0.75))
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > self.rating {
            return self.offImage ?? self.onImage
        } else {
            return self.onImage
        }
    }
}
