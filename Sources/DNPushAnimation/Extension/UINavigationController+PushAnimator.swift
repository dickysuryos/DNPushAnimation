//
//  UINavigationController+PushAnimator.swift
//  DNPushAnimation
//
//  Created by dicky suryo on 15/09/25.
//
import UIKit

public extension UINavigationController {
    /// Enable custom push/pop animations.
    /// - Parameters:
    ///   - animationType: The style of transition (slide, fade, zoom…)
    ///   - options: Tuning parameters
    ///   - interactivePop: enable edge-swipe-to-pop
    /// - Returns: the transition controller (keep a strong reference!)
    @discardableResult
    func usePushAnimator(animationType: PushAnimationType = .slide,
                         options: PushAnimator.Options = .init(),
                         interactivePop: Bool = true) -> NavigationTransitionController {
        let controller = NavigationTransitionController(
            navigationController: self,
            animationType: animationType,
            options: options
        )
        controller.isInteractivePopEnabled = interactivePop
        return controller
    }
}
