//
//  CoordinatorViewController.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/11/2022.
//

import SwiftUI

// MARK: - CoordinatorViewControllerDelegate
public protocol CoordinatorViewControllerDelegate: AnyObject {
    /// Notifies the object that the view controller was dismissed modally via a sheet
    /// - Parameter vc: The view controller that was dismissed
    func viewDidDismissModally(vc: UIViewController)

    /// Notifies the object that the view controller was popped on the navigation stack
    /// - Parameter vc: The view controller that was popped on the navigation stack
    func viewDidPop(vc: UIViewController)
}

// MARK: - CoordinatorViewController
open class CoordinatorViewController: UIViewController {
    open weak var delegate: CoordinatorViewControllerDelegate?
    public var isAppeared = false

    public init(controller: UIViewController) {
        super.init(nibName: nil, bundle: nil)

        controller.view.backgroundColor = .clear
        addChild(controller)
        view.addSubview(controller.view)

        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        controller.didMove(toParent: self)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAppeared = true
        /// Post coordinator view did appear notification
        NotificationCenter.default.post(name: .coordinatorViewDidAppear, object: self)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isAppeared = false

        // If the view is being popped on the navigation stack
        if isMovingFromParent {
            delegate?.viewDidPop(vc: self)
        } else if isBeingDismissedModally {
            // If the view id being dismissed via a model presentation
            delegate?.viewDidDismissModally(vc: self)
        }
    }

    deinit {
        log("🚮 Deinit \(String(describing: self))", type: .info)
    }
}

private extension CoordinatorViewController {
    /// Used to identify if a view controller is being dismissed via a modal presentation
    var isBeingDismissedModally: Bool {
        navigationController?.isBeingDismissed == true || isBeingDismissed == true
    }
}

public extension Notification.Name {
    /// CoordinatorViewController will post this notification whenever view did appear.
    static let coordinatorViewDidAppear = Notification.Name("coordinatorViewDidAppear")
}
