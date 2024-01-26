//
//  AppCoordinator.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import Foundation
import UIKit

class AppCoordinator: MainCoordinator {
    init(items: [ParentCoordinator]) {
        super.init()

        let tabBarVc = UITabBarController()
        tabBarVc.viewControllers = items.compactMap(\.vc)
        setup(vc: tabBarVc, items: items)
        // Create a link between parent items and this main one
        items.forEach { item in
            item.main = self
        }

        /// For Phase 1 we only have one view controller, so we are hiding the tab bar.
        /// Remove this line to display the tab bar.
        tabBarVc.tabBar.isHidden = true
    }
}
