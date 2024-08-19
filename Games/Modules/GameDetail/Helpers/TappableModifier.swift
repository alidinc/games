//
//  TappableModifier.swift
//  Games
//
//  Created by Ali Dinç on 19/08/2024.
//

import SwiftUI

struct TappablePadding: ViewModifier {
  let insets: EdgeInsets
  let onTap: () -> Void

  func body(content: Content) -> some View {
    content
      .padding(insets)
      .contentShape(Rectangle())
      .onTapGesture {
        onTap()
      }
      .padding(insets.inverted)
  }
}

extension View {
  func tappablePadding(_ insets: EdgeInsets, onTap: @escaping () -> Void) -> some View {
    self.modifier(TappablePadding(insets: insets, onTap: onTap))
  }
}

extension EdgeInsets {
  var inverted: EdgeInsets {
    .init(top: -top, leading: -leading, bottom: -bottom, trailing: -trailing)
  }
}
