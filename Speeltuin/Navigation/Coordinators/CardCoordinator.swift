//
//  CardCoordinator.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/11/2022.
//

// CardCoordinator
//
// This is the card coordinator that all coordinators presenting a bottom sheet will subclass.
//

import SwiftUI

open class CardCoordinator: NSObject, CoordinatorItem {
    public let id: UUID = .init()

    public private(set) weak var main: MainCoordinator? // <- This is the main coordinator you'll be adding the card on

    public private(set) var vc: UIViewController?

    public func setup(
        main: MainCoordinator,
        vc: UIViewController
    ) {
        self.main = main
        self.vc = vc
    }

    deinit {
        log("🚮 Deinit \(String(describing: self))", type: .info)
    }
}
