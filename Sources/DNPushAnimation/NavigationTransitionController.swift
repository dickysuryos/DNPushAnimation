//
//  NavigationTransitionController.swift
//  DNPushAnimation
//
//  Created by dicky suryo on 15/09/25.
//

import UIKit

/// UINavigationControllerDelegate that wires up PushAnimator
/// with a configurable animation type and options.
public final class NavigationTransitionController: NSObject, UINavigationControllerDelegate {

    public var animationType: PushAnimationType
    public var options: PushAnimator.Options

    private weak var navigationController: UINavigationController?
    private var interactiveTransition: UIPercentDrivenInteractiveTransition?
    private var edgePanGesture: UIScreenEdgePanGestureRecognizer?

    public var isInteractivePopEnabled: Bool = true {
        didSet { edgePanGesture?.isEnabled = isInteractivePopEnabled }
    }

    public init(navigationController: UINavigationController,
                animationType: PushAnimationType = .slide,
                options: PushAnimator.Options = .init()) {
        self.navigationController = navigationController
        self.animationType = animationType
        self.options = options
        super.init()
        navigationController.delegate = self
        attachEdgePan(to: navigationController)
    }

    // MARK: UINavigationControllerDelegate

    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let direction: Direction = (operation == .push) ? .push : .pop
        return PushAnimator(type: animationType, direction: direction, options: options)
    }

    public func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }

    // MARK: Edge Pan

    private func attachEdgePan(to nav: UINavigationController) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        gesture.edges = .left
        gesture.delegate = self
        nav.view.addGestureRecognizer(gesture)
        self.edgePanGesture = gesture
    }

    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard let nav = navigationController else { return }
        let translation = gesture.translation(in: gesture.view)
        let width = max(1, gesture.view?.bounds.width ?? 1)
        var progress = translation.x / width
        progress = max(0, min(1, progress))

        switch gesture.state {
        case .began:
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            nav.popViewController(animated: true)
        case .changed:
            interactiveTransition?.update(progress)
        case .ended, .cancelled, .failed:
            let velocity = gesture.velocity(in: gesture.view).x
            if progress > 0.35 || velocity > 800 {
                interactiveTransition?.finish()
            } else {
                interactiveTransition?.cancel()
            }
            interactiveTransition = nil
        default: break
        }
    }
}

extension NavigationTransitionController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nav = navigationController else { return false }
        return nav.viewControllers.count > 1
    }
}
