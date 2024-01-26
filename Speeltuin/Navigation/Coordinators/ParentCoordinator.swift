//
//  ParentCoordinator.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/11/2022.
//

import UIKit

// MARK: - ParentCoordinatorItem
// ParentCoordinator
//
// This is the base protocol for any coordinators that will have any children
//

public protocol ParentCoordinatorItem: AnyObject {
    var childCoordinators: [CoordinatorItem] { get }
}

// MARK: - ParentCoordinator
// ParentCoordinator
//
// This is the parent coordinator that all child coordinators will live in
//

open class ParentCoordinator: CoordinatorItem, ParentCoordinatorItem {
    public let id: UUID = .init()

    public private(set) var childCoordinators: [CoordinatorItem] = []

    public private(set) var vc: UIViewController?

    public var main: MainCoordinator?

    public func setup(
        main: MainCoordinator?,
        vc: UIViewController
    ) {
        self.main = main
        self.vc = vc
        configureDelegate(from: vc)
    }

    public init() {}

    deinit {
        log("🚮 Deinit \(String(describing: self))", type: .info)
    }

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

// MARK: CoordinatorModalPresentationActions
extension ParentCoordinator: CoordinatorModalPresentationActions {
    public func present(
        coor: CoordinatorItem,
        config: SheetPresentationConfig
    ) {
        main?.present(coor: coor, config: config)
    }

    public func presentFullScreen(
        coor: CoordinatorItem,
        modalPresentationStyle: UIModalPresentationStyle,
        animated: Bool
    ) {
        main?.presentFullScreen(coor: coor, modalPresentationStyle: modalPresentationStyle, animated: animated)
    }
}

// MARK: CoordinatorViewControllerDelegate
extension ParentCoordinator: CoordinatorViewControllerDelegate {
    public func viewDidDismissModally(vc _: UIViewController) {
        main?.remove(child: self)
    }

    public func viewDidPop(vc _: UIViewController) {
        main?.remove(child: self)
    }
}

// MARK: CoordinatorAction
extension ParentCoordinator: CoordinatorAction {
    public func add(child: CoordinatorItem) {
        childCoordinators.append(child)
    }

    public func remove(child: CoordinatorItem) {
        childCoordinators.removeAll(where: { $0.id == child.id })
    }
}
