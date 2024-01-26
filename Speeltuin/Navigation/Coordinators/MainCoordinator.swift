//
//  MainCoordinator.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/11/2022.
//

import UIKit

// MARK: - MainCoordinator
// MainCoordinator
//
// This is the root coordinator. The main one that the app will use within the app.
// We should setup the tab bar using this coordinator and there should only be one main
// coordinator within the codebase
//

open class MainCoordinator: CoordinatorItem, ParentCoordinatorItem {
    public let id: UUID = .init()

    public private(set) var childCoordinators: [CoordinatorItem] = []

    public private(set) var vc: UIViewController?

    public init() {}

    public func setup(
        vc: UIViewController,
        items: [ParentCoordinator]
    ) {
        self.vc = vc
        childCoordinators = items
    }

    public func removeAllChildren() {
        childCoordinators.removeAll()
    }
}

// MARK: CoordinatorModalPresentationActions
extension MainCoordinator: CoordinatorModalPresentationActions {
    public func present(
        coor: CoordinatorItem,
        config: SheetPresentationConfig = .init()
    ) {
        if
            let coorVC = coor.vc,
            let sheet = vc?.sheetPresentationController {
            sheet.detents = config.detents
            sheet.largestUndimmedDetentIdentifier = config.largestUndimmedDetentIdentifier
            sheet.prefersScrollingExpandsWhenScrolledToEdge = config.prefersScrollingExpandsWhenScrolledToEdge
            sheet.prefersEdgeAttachedInCompactHeight = config.prefersEdgeAttachedInCompactHeight
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = config
                .widthFollowsPreferredContentSizeWhenEdgeAttached

            vc?.present(coorVC, animated: true)
        }
    }

    /// Present a coordinator on top of the main coordinator, this will present it using a sheet
    /// - Parameters:
    ///   - coor: The coordinator feature you want to present
    ///   - modalPresentationStyle: Modal presentation styles available when presenting view controllers.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false. Default is true.
    public func presentFullScreen(
        coor: CoordinatorItem,
        modalPresentationStyle: UIModalPresentationStyle = .overCurrentContext,
        animated: Bool = true
    ) {
        if
            let coorVC = coor.vc {
            coorVC.modalPresentationStyle = modalPresentationStyle
            vc?.present(coorVC, animated: animated)
        }
    }
}

// MARK: CoordinatorAction
extension MainCoordinator: CoordinatorAction {
    public func add(child: CoordinatorItem) {
        childCoordinators.append(child)
    }

    public func remove(child: CoordinatorItem) {
        childCoordinators.removeAll(where: { $0.id == child.id })
    }
}

// MARK: - CardCoordinator

public extension MainCoordinator {
    enum TransitionLocation {
        case top
        case bottom
    }

    /// Show a bottom sheet coordinator by adding it as a child view controller to the main view controller.
    /// Animation of the bottom sheet is handled inside this method, so all the content actions dismiss with animation.
    /// - Parameter cardCoor: The card coordinator that is being presented.
    func show(cardCoor: CardCoordinator, withAnimation: Bool = true, transitionFrom: TransitionLocation) {
        if
            let rootVC = vc,
            let coorVC = cardCoor.vc {
            rootVC.addChild(coorVC)
            rootVC.view.addSubview(coorVC.view)

            coorVC.view.translatesAutoresizingMaskIntoConstraints = false

            switch transitionFrom {
            case .top:
                coorVC.view.topAnchor.constraint(equalTo: rootVC.view.topAnchor).isActive = true
            case .bottom:
                coorVC.view.bottomAnchor.constraint(equalTo: rootVC.view.bottomAnchor).isActive = true
            }

            NSLayoutConstraint.activate([
                coorVC.view.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor),
                coorVC.view.trailingAnchor.constraint(equalTo: rootVC.view.trailingAnchor),
            ])

            coorVC.didMove(toParent: vc)

            if withAnimation {
                coorVC.view.frame.origin.y = UIScreen.main.bounds.height

                UIView.animate(withDuration: 0.5) {
                    coorVC.view.frame.origin.y = UIScreen.main.bounds.height - coorVC.view.frame.height
                }
            }
        }
    }

    /// Remove the bottom sheet from the view.
    /// Animation of the bottom sheet is handled inside this method, so all the content actions dismiss with animation.
    /// - Parameter cardCoor: The card coordinator that is being removed.
    func remove(
        cardCoor: CardCoordinator,
        withAnimation: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        if let coorVC = cardCoor.vc {
            if withAnimation {
                UIView.animate(withDuration: 0.4) {
                    coorVC.view.frame.origin.y = UIScreen.main.bounds.height
                } completion: { [weak self] _ in
                    guard let self else {
                        return
                    }
                    coorVC.removeFromParent()
                    coorVC.view.removeFromSuperview()
                    remove(child: cardCoor)
                    completion?()
                }
            } else {
                coorVC.removeFromParent()
                coorVC.view.removeFromSuperview()
                remove(child: cardCoor)
            }
        }
    }
}
