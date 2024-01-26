//
//  Coordinator.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/11/2022.
//

import UIKit

// MARK: - CoordinatorItem
// CoordinatorItem
//
// This is the base protocol for all coordinator items
//

public protocol CoordinatorItem: AnyObject {
    /// The unique identifier of the coordinator item
    var id: UUID { get }

    /// The view controller that will hold the view within the coordinator
    var vc: UIViewController? { get }
}

// MARK: - CoordinatorModalPresentationActions
// CoordinatorModalPresentationActions
//
// This is the base protocol for all coordinator actions that could happen
//

public protocol CoordinatorModalPresentationActions {
    /// Present a coordinator on top of the main coordinator, this will present it using a sheet
    /// - Parameters:
    ///   - coor: The coordinator feature you want to present
    ///   - config: The configuration of the sheet
    func present(coor: CoordinatorItem, config: SheetPresentationConfig)

    /// Present a coordinator on top of the main coordinator, this will present it using a sheet
    /// - Parameters:
    ///   - coor: The coordinator feature you want to present
    ///   - config: The configuration of the sheet
    func presentFullScreen(coor: CoordinatorItem, modalPresentationStyle: UIModalPresentationStyle, animated: Bool)

    /// Dismss a coordinator that is being presented on top of the main coordinator, by passing in the coordinator you want. In order to dismiss a screen you need either access main from the parent or the child.
    /// - Parameters:
    ///   - coor: The coordinator to dismiss
    ///   - animated: Should it animate the dismissal?
    ///   - completion: Perform any actions after the coordinator has been dismissed
    func dismiss(coor: CoordinatorItem, animated: Bool, completion: (() -> Void)?)
}

public extension CoordinatorModalPresentationActions {
    func dismiss(coor: CoordinatorItem, animated: Bool = true, completion: (() -> Void)? = nil) {
        coor.vc?.dismiss(animated: animated, completion: completion)
    }
}

// MARK: - CoordinatorAction
// CoordinatorAction
//
// This is the base protocol for all coordinator memory management, this could be adding or removing them
//

public protocol CoordinatorAction {
    /// Adds the child into memory so it's kept alive
    /// - Parameter child: The coordinator to add into memory
    func add(child: CoordinatorItem)

    /// Removed the child from memory so it's disposed of
    /// - Parameter child: The coordinator to remove from memory
    func remove(child: CoordinatorItem)
}
