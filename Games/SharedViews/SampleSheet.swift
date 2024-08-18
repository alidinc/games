//
//  SampleSheet.swift
//  Games
//
//  Created by Ali Dinç on 18/08/2024.
//

import SwiftUI

struct SampleSheetView<Content: View>: View {

    var title: String
    var subtitle: String?
    var image: Config
    var button1: Config?
    var button2: Config?
    let optionalView: Content?

    init(title: String,
         subtitle: String? = nil,
         image: Config,
         button1: Config? = nil,
         button2: Config? = nil,
         @ViewBuilder optionalView: () -> Content = { EmptyView() }) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.button1 = button1
        self.button2 = button2
        self.optionalView = optionalView()
    }

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: image.content)
                .font(.title)
                .foregroundStyle(image.foreground)
                .frame(width: 65, height: 65)
                .background(image.tint.gradient, in: .circle)
                .background {
                    Circle()
                        .stroke(Color.background, lineWidth: 8)
                }

            if let subtitle {
                VStack(alignment: .center, spacing: 6) {
                    Text(title)
                        .font(.title3.bold())

                    Text(subtitle)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .foregroundStyle(.gray)
                        .padding(.vertical, 6)
                }
            } else {
                Text(title)
                    .font(.title3.bold())
            }


            if let optionalView {
                optionalView
            }

            VStack(spacing: 12) {
                if let button1 {
                    ButtonView(button1)
                }

                if let button2 {
                    ButtonView(button2)
                        .padding(.top, -5)
                }
            }
        }
        .padding([.horizontal, .bottom], 15)
        .hSpacing(.center)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background)
                .padding(.top, 30)
        }
        .shadow(color: .black.opacity(0.12), radius: 12)
        .padding(.horizontal, 15)
    }

    @ViewBuilder
    func ButtonView(_ config: Config) -> some View {
        Button {
            config.action()
        } label: {
            Text(config.content)
                .fontWeight(.bold)
                .foregroundStyle(config.foreground)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10))
        }
    }

    struct Config {
        var content: String
        var tint: Color
        var foreground: Color
        var action: () -> () = {  }
    }
}

