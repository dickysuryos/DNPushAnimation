//
//  Transition+PushAnimator.swift
//  DNPushAnimation
//
//  Created by dicky suryo on 18/09/25.
//

import UIKit

// MARK: - Transitioning
extension PushAnimator: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    options.duration
    }
    
    public func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        guard let fromVC = ctx.viewController(forKey: .from),
        let toVC = ctx.viewController(forKey: .to) else {
        ctx.completeTransition(false); return
        }
        
    let container = ctx.containerView
    let fromView = fromVC.view!
    let toView = toVC.view!
    let width = container.bounds.width
    let height = container.bounds.height
    let duration = transitionDuration(using: ctx)


    switch type {
        case .slide:
        runSlideAnimation(ctx: ctx, container: container, fromView: fromView, toView: toView, width: width, height: height, duration: duration)
        case .fade:
        runFadeAnimation(ctx: ctx, container: container, fromView: fromView, toView: toView, duration: duration)
        case .zoom:
        runZoomAnimation(ctx: ctx, container: container, fromView: fromView, toView: toView, duration: duration)
        case .flip:
        runFlipAnimation(ctx: ctx, container: container, fromView: fromView, toView: toView, duration: duration)
        case .card:
        runCardAnimation(ctx: ctx, container: container, fromView: fromView, toView: toView, duration: duration)
        case .drawer:
        runDrawerAnimation(ctx: ctx, container: container, fromView: fromView, toView: toView, width: width, height: height, duration: duration)
        case .scaleUp:
        runScaleUpAnimation(ctx: ctx, container: container, fromView: fromView, toView: toView, duration: duration)
        case .dissolve:
        runDissolveAnimation(ctx: ctx, container: container, fromView: fromView, toView: toView, duration: duration)
        case .custom(let block):
        block(ctx)
        }
    }
}
