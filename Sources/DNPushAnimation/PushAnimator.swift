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
    public var parallax: CGFloat // 0...1 portion of width
    public var addsShadow: Bool
    public var scaleOnPush: CGFloat // 0.95 = subtle scale down of fromVC while pushing


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

    public let options: Options
    public init(options: Options = .init()) { self.options = options }
}

extension PushAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        options.duration
    }
    
    
    public func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        guard let fromVC = ctx.viewController(forKey: .from), let toVC = ctx.viewController(forKey: .to)
        else { ctx.completeTransition(false); return
        }
        
        
        let container = ctx.containerView
        let isPush = toVC.navigationController?.viewControllers.contains(toVC) == true &&
        toVC.presentingViewController == nil &&
        toVC.navigationController?.topViewController == toVC
        
        
        let width = container.bounds.width
        let height = container.bounds.height
        
        
        let fromView = fromVC.view!
        let toView = toVC.view!
        
        
        // Ensure proper hierarchy
        if isPush { container.addSubview(toView) } else { container.insertSubview(toView, belowSubview: fromView) }
        
        
        // Prepare initial states
        if isPush {
            toView.frame = CGRect(x: width, y: 0, width: width, height: height)
            if options.addsShadow { toView.applyDropShadow() }
        } else {
            toView.frame = container.bounds
            if options.addsShadow { fromView.applyDropShadow() }
            
        }
        
        
        // Parallax amount for the underlying view
        let parallaxOffset = width * options.parallax
        
        
        // Optional scale on push
        let initialScale = options.scaleOnPush
        if isPush && initialScale < 1.0 { fromView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) }
        
        
        let duration = transitionDuration(using: ctx)
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: options.dampingRatio) {
            if isPush {
                toView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                fromView.frame = fromView.frame.offsetBy(dx: -parallaxOffset, dy: 0)
                if initialScale < 1.0 { fromView.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
                }
            } else {
                // POP
                fromView.frame = CGRect(x: width, y: 0, width: width, height: height)
                toView.frame = toView.frame.offsetBy(dx: parallaxOffset, dy: 0)
            }
        }
        animator.addCompletion { position in
            let completed = !ctx.transitionWasCancelled
            if !completed {
                // Revert
                toView.removeFromSuperview()
                fromView.transform = .identity
                fromView.layer.shadowOpacity = 0
            } else {
                toView.layer.shadowOpacity = 0
                fromView.transform = .identity
            }
            // Reset any parallax offset on toView if we popped
            if !isPush {
                toView.frame = container.bounds
            }
            ctx.completeTransition(completed)
            
        }
        animator.startAnimation()
        
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
