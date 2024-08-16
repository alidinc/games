//
//  SheetPresentationConfig.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/11/2022.
//


import UIKit

// SheetPresentationConfig
//
// This is the base protocol for the main coordinator that will host the children
//

public struct SheetPresentationConfig {
    public typealias PresentationDetentsIdentitifer = UISheetPresentationController.Detent.Identifier

    let detents: [UISheetPresentationController.Detent]
    let largestUndimmedDetentIdentifier: PresentationDetentsIdentitifer
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    let widthFollowsPreferredContentSizeWhenEdgeAttached: Bool

    public init(
        detents: [UISheetPresentationController.Detent] = [.large()],
        largestUndimmedDetentIdentifier: PresentationDetentsIdentitifer = .large,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
        prefersEdgeAttachedInCompactHeight: Bool = true,
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = true
    ) {
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
    }
}
