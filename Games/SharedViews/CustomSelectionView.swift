//
//  CustomSelectionView.swift
//  Games
//
//  Created by Ali Dinç on 17/08/2024.
//

import SwiftUI

struct CustomSelectionView: View {

    struct Config {
        var titleFont: Font = .body
        var titleFontWeight: Font.Weight = .regular
        var subtitleFont: Font = .caption
        var subtitleFontWeight: Font.Weight = .regular
        var showChevron: Bool = true
    }

    var imageName: String?
    var assetName: String?
    var title: LocalizedStringResource
    var subtitle: LocalizedStringResource
    var config: Config = .init()

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack {
            if let assetName = assetName {
                Image(assetName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(.rect(cornerRadius: 8))
                    .shadow(color: scheme == .dark ? .white.opacity(0.1) : .black.opacity(0.2), radius: 10)
            } else if let imageName = imageName {
                Image(systemName: imageName)
            }

            VStack(alignment: .leading) {
                Text(title)
                    .font(config.titleFont)
                    .fontWeight(config.titleFontWeight)

                Text(subtitle)
                    .font(config.subtitleFont)
                    .fontWeight(config.subtitleFontWeight)
                    .tint(.secondary)
            }
            Spacer()
            if config.showChevron {
                Image(systemName: "chevron.up.chevron.down")
                    .tint(.secondary)
            }
        }
        .tint(.primary)
    }
}
