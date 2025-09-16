//
//  UINavigationController+PushAnimator.swift
//  DNPushAnimation
//
//  Created by dicky suryo on 15/09/25.
//
import UIKit

public extension UINavigationController {
/// Call this once (e.g., in your root VC's `viewDidLoad` or in SceneDelegate) to enable the custom push/pop animations.
/// - Parameters:
/// - options: Animation tuning parameters
/// - interactivePop: enable edge-swipe-to-pop
/// - Returns: the transition controller, retain it (e.g., as a property) to keep it alive
@discardableResult
func usePushAnimator(options: PushAnimator.Options = .init(), interactivePop: Bool = true) -> NavigationTransitionController {
    let controller = NavigationTransitionController(navigationController: self, animator: PushAnimator(options: options))
    controller.isInteractivePopEnabled = interactivePop
    return controller
}
}
