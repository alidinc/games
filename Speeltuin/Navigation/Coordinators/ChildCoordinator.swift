//
//  ChildCoordinator.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/11/2022.
//

import UIKit

// MARK: - ChildCoordinator
// ChildCoordinator
//
// This is the child coordinator that all coordinators will subclass
//

open class ChildCoordinator: NSObject, CoordinatorItem {
    public let id: UUID = .init()

    public private(set) weak var parent: ParentCoordinator? // <- This is the main coordinator you'll push on

    public private(set) var vc: UIViewController?

    public func setup(
        parent: ParentCoordinator,
        vc: UIViewController
    ) {
        self.parent = parent
        self.vc = vc
        configureDelegate(from: vc)
    }

    deinit {
        log("🚮 Deinit \(String(describing: self))", type: .info)
    }

    /// Setup the delegate between the coordinator view controller container to handle telling the coordinator when the view is no longer on the screen
    /// - Parameter vc: The view controller to hook up the delegate with
    func configureDelegate(from vc: UIViewController) {
        if
            let nav = vc as? UINavigationController,
            let childVC = nav.viewControllers.first as? CoordinatorViewController {
            childVC.delegate = self
        } else if let childVC = vc as? CoordinatorViewController {
            childVC.delegate = self
        } else {
            log("Unable to set the delegate on the container controller", type: .warning)
        }
    }
}

// MARK: CoordinatorViewControllerDelegate
extension ChildCoordinator: CoordinatorViewControllerDelegate {
    public func viewDidPop(vc _: UIViewController) {
        // If on the parent there are children then remove the last item in the coordinator stack
        parent?.remove(child: self)
    }

    public func viewDidDismissModally(vc _: UIViewController) {
        parent?.remove(child: self)
        // This is here to prevent objects that are within a sheet which hold a stack of items. We want to not only remove this child from the parent but also remove the parent since this has been dismissed too and shouldn't be in memory anymore
        if let parent {
            parent.main?.remove(child: parent)
        }
    }
}

public extension ChildCoordinator {
    /// Used to push a coordinator on the top most view controllers navigation stack
    /// - Parameter flag: Should it be animated or not?
    func push(animated flag: Bool = true) {
        guard
            let nav = parent?.vc as? UINavigationController,
            let vc
        else {
            log("😅 Attempting to push on a view controller that isn't a navigation controller", type: .warning)
            return
        }

        nav.pushViewController(vc, animated: flag)
    }

    /// Used to pop a coordinator from the top most view controllers navigation stack
    /// - Parameter flag: Should it be animated or not?
    func pop(animated flag: Bool = true) {
        guard let nav = parent?.vc as? UINavigationController
        else {
            log("😅 Attempting to pop on a view controller that isn't a navigation controller", type: .warning)
            return
        }

        nav.popViewController(animated: flag)
    }

    /// Used to present a coordinator on the top most view controllers navigation stack
    /// - Parameter flag: Should it be animated or not?
    func present(
        modalPresentationStyle: UIModalPresentationStyle = .overCurrentContext,
        isModalInPresentation: Bool = false,
        animated flag: Bool = true
    ) {
        if let childVC = vc {
            childVC.isModalInPresentation = isModalInPresentation
            childVC.modalPresentationStyle = modalPresentationStyle
            parent?.vc?.present(childVC, animated: flag)
        }
    }

    /// Used to dismiss a coordinator.
    /// - Parameter flag: Should it be animated or not?
    func dismiss(animated flag: Bool = true) {
        if let vc {
            vc.dismiss(animated: flag)
        }
    }
}
