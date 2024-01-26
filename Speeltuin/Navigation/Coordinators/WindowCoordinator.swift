//
//  WindowCoordinator.swift
//  Speeltuin
//
//  Created by Ali Dinç on 22/11/2022.
//

import UIKit

// MARK: - WindowCoordinator
/// UIWindow based coordinator
///
/// This is the UIWindow Coordinator that all coordinators will subclass
/// Example:
/// Create subclass by inheriting WindowCoordinator class.
///
/// ```
///  class ErrorPopupWindowCoordinator: WindowCoordinator {
///     init(model: ErrorPopupModel) {
///         super.init()
///         let popupErrorView = ErrorPopupView(model: model) { [weak self] in
///             guard let self else {
///                 return
///             }
///             self.dismiss()
///         }
///         let hosting = UIHostingController(rootView: popupErrorView)
///         let vc = CoordinatorViewController(controller: hosting)
///         setup(window: SceneDelegate.createWindow(), vc: vc)
///     }
///  }
/// ```
/// Now create instance and call `show()` method.
/// ```
/// let coor = ErrorPopupWindowCoordinator(model: errorModel, main: main)
/// coor.show()
/// ```
/// Use `dismiss()` method to remove previously shown  coordinator
/// ```
/// coor.dismiss()
/// ```
open class WindowCoordinator: NSObject, CoordinatorItem {
    public let id: UUID = .init()

    public private(set) var vc: UIViewController?
    public private(set) var windowQueue: WindowCoordinatorQueue?
    public private(set) var window: UIWindow?

    public func setup(window: UIWindow?, windowQueue: WindowCoordinatorQueue = .default, vc: UIViewController) {
        self.window = window
        self.windowQueue = windowQueue
        self.vc = vc

        self.window?.rootViewController = UIViewController() // Dummy view controller
        self.window?.windowLevel = .statusBar + 1
        self.window?.isHidden = false
        configureDelegate(from: vc)

        self.windowQueue?.add(child: self)
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

    func removeWindow() {
        window?.isHidden = false
        window = nil
    }
}

// MARK: CoordinatorViewControllerDelegate
extension WindowCoordinator: CoordinatorViewControllerDelegate {
    public func viewDidPop(vc _: UIViewController) {
        windowQueue?.remove(child: self)
        removeWindow()
    }

    public func viewDidDismissModally(vc _: UIViewController) {
        windowQueue?.remove(child: self)
        removeWindow()
    }
}

public extension WindowCoordinator {
    @discardableResult
    func show(
        style: UIModalPresentationStyle = .overCurrentContext,
        isModalInPresentation: Bool = false,
        animated flag: Bool = true
    )
        -> Bool {
        if let window, let childVC = vc {
            childVC.isModalInPresentation = isModalInPresentation
            childVC.modalPresentationStyle = style
            window.rootViewController?.present(childVC, animated: flag)
            return true
        }
        return false
    }

    func dismiss(animated: Bool = true) {
        let task = {
            self.windowQueue?.remove(child: self)
            self.removeWindow()
        }
        if let presentedVC = vc {
            presentedVC.dismiss(animated: animated) {
                task()
            }
        } else {
            task()
        }
    }
}

// MARK: - WindowCoordinatorQueue
/// Managed window coordinator queue
final public class WindowCoordinatorQueue {
    public static let `default` = WindowCoordinatorQueue()

    public private(set) var items: [CoordinatorItem] = []
    public init() {}

    public func add(child: CoordinatorItem) {
        items.append(child)
    }

    public func remove(child: CoordinatorItem) {
        items.removeAll(where: { $0.id == child.id })
    }
}
