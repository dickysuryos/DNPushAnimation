    //
    //  PushAnimator.swift
    //  DNPushAnimation
    //
    //  Created by dicky suryo on 15/09/25.
    //

    import UIKit

public final class PushAnimator: NSObject {
    public struct Options: Sendable {
        public var duration: TimeInterval
        public var dampingRatio: CGFloat
        public var parallax: CGFloat
        public var addsShadow: Bool
        public var scaleOnPush: CGFloat

        public init(duration: TimeInterval = 0.36,
                    dampingRatio: CGFloat = 0.92,
                    parallax: CGFloat = 0.25,
                    addsShadow: Bool = true,
                    scaleOnPush: CGFloat = 0.98) {
            self.duration = duration
            self.dampingRatio = dampingRatio
            self.parallax = parallax
            self.addsShadow = addsShadow
            self.scaleOnPush = scaleOnPush
        }
    }

    public let type: PushAnimationType
    public let direction: Direction
    public let options: Options

    public init(type: PushAnimationType = .slide,
                direction: Direction,
                options: Options = .init()) {
        self.type = type
        self.direction = direction
        self.options = options
    }
}
extension PushAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        options.duration
    }
    
    
    public func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        guard
            let fromVC = ctx.viewController(forKey: .from),
            let toVC = ctx.viewController(forKey: .to)
        else { ctx.completeTransition(false); return }

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
        }
    }
}

private extension UIView {
    func applyDropShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.18
    layer.shadowRadius = 10
    layer.shadowOffset = CGSize(width: -2, height: 0)
    layer.masksToBounds = false
    }
}
