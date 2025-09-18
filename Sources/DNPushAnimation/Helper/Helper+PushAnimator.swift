//
//  Helper+PushAnimator.swift
//  DNPushAnimation
//
//  Created by dicky suryo on 18/09/25.
//
import UIKit
import Foundation

public extension PushAnimator {
    
    func runDissolveAnimation(ctx: UIViewControllerContextTransitioning,
                              container: UIView,
                              fromView: UIView,
                              toView: UIView,
                              duration: TimeInterval) {
        if direction == .push { container.addSubview(toView) } else { container.insertSubview(toView, belowSubview: fromView) }
        toView.alpha = (direction == .push) ? options.dissolveFromAlpha : 1

        var blurView: UIVisualEffectView?
        if options.blurOnDissolve {
            let bv = UIVisualEffectView(effect: nil)
            bv.frame = fromView.bounds
            fromView.addSubview(bv)
            blurView = bv
            UIView.animate(withDuration: duration * 0.8) { bv.effect = UIBlurEffect(style: .systemMaterial) }
        }

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            if self.direction == .push {
                toView.alpha = 1
                fromView.alpha = 0
            } else {
                fromView.alpha = 0
            }
        } completion: { _ in
            blurView?.removeFromSuperview()
            fromView.alpha = 1
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }
    
    func runScaleUpAnimation(ctx: UIViewControllerContextTransitioning,
                                 container: UIView,
                                 fromView: UIView,
                                 toView: UIView,
                                 duration: TimeInterval) {
            switch direction {
            case .push:
                container.addSubview(toView)
                toView.transform = CGAffineTransform(scaleX: options.scaleUpInitialScale, y: options.scaleUpInitialScale)
                toView.alpha = options.dissolveFromAlpha
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
                    toView.transform = .identity
                    toView.alpha = 1
                    fromView.alpha = 0.95
                } completion: { _ in
                    fromView.alpha = 1
                    ctx.completeTransition(!ctx.transitionWasCancelled)
                }
            case .pop:
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
                    fromView.transform = CGAffineTransform(scaleX: self.options.scaleUpInitialScale, y: self.options.scaleUpInitialScale)
                    fromView.alpha = 0
                } completion: { _ in
                    fromView.transform = .identity
                    fromView.alpha = 1
                    ctx.completeTransition(!ctx.transitionWasCancelled)
                }
            }
        }
    func runDrawerAnimation(ctx: UIViewControllerContextTransitioning,
                                container: UIView,
                                fromView: UIView,
                                toView: UIView,
                                width: CGFloat,
                                height: CGFloat,
                                duration: TimeInterval) {
            let drawerWidth = max(200, min(width, width * options.drawerWidthRatio))
            let dimTag = 9991
            switch direction {
            case .push:
                // Dim background
                let dim = UIView(frame: container.bounds)
                dim.backgroundColor = UIColor.black.withAlphaComponent(0)
                dim.tag = dimTag
                container.addSubview(dim)

                // Drawer view
                container.addSubview(toView)
                toView.frame = CGRect(x: width, y: 0, width: drawerWidth, height: height)

                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
                    toView.frame.origin.x = width - drawerWidth
                    dim.backgroundColor = UIColor.black.withAlphaComponent(self.options.drawerDimOpacity)
                    fromView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                } completion: { _ in
                    ctx.completeTransition(!ctx.transitionWasCancelled)
                }
            case .pop:
                let dim = container.viewWithTag(dimTag)
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
                    fromView.frame.origin.x = width
                    dim?.backgroundColor = UIColor.black.withAlphaComponent(0)
                    toView.transform = .identity
                } completion: { _ in
                    dim?.removeFromSuperview()
                    ctx.completeTransition(!ctx.transitionWasCancelled)
                }
            }
        }
    
    func runCardAnimation(ctx: UIViewControllerContextTransitioning,
                              container: UIView,
                              fromView: UIView,
                              toView: UIView,
                              height: CGFloat,
                              duration: TimeInterval) {
            switch direction {
            case .push:
                container.addSubview(toView)
                toView.frame = CGRect(x: 0, y: container.bounds.height, width: container.bounds.width, height: height)
                toView.layer.cornerRadius = options.cardCornerRadius
                toView.clipsToBounds = true
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: options.cardSpringDamping,
                               initialSpringVelocity: options.cardSpringVelocity,
                               options: .curveEaseOut) {
                    toView.frame = container.bounds
                } completion: { _ in
                    toView.layer.cornerRadius = 0
                    ctx.completeTransition(!ctx.transitionWasCancelled)
                }
            case .pop:
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
                    fromView.frame.origin.y = container.bounds.height
                } completion: { _ in
                    ctx.completeTransition(!ctx.transitionWasCancelled)
                }
            }
        }
    func runSlideAnimation(ctx: UIViewControllerContextTransitioning,
                               container: UIView,
                               fromView: UIView,
                               toView: UIView,
                               width: CGFloat,
                               height: CGFloat,
                               duration: TimeInterval) {
            switch direction {
            case .push:
                container.addSubview(toView)
                toView.frame = CGRect(x: width, y: 0, width: width, height: height)
                if options.addsShadow { toView.addDropShadow() }
            case .pop:
                container.insertSubview(toView, belowSubview: fromView)
                toView.frame = container.bounds
                if options.addsShadow { fromView.addDropShadow() }
            }

            let parallaxOffset = width * options.parallax
            fromView.transform = .identity

            let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: options.dampingRatio) {
                switch self.direction {
                case .push:
                    toView.frame = container.bounds
                    fromView.frame = fromView.frame.offsetBy(dx: -parallaxOffset, dy: 0)
                    if self.options.scaleOnPush < 1.0 {
                        fromView.transform = CGAffineTransform(scaleX: self.options.scaleOnPush, y: self.options.scaleOnPush)
                    }
                case .pop:
                    fromView.frame = CGRect(x: width, y: 0, width: width, height: height)
                }
            }
            animator.addCompletion { _ in
                fromView.transform = .identity
                toView.layer.shadowOpacity = 0
                fromView.layer.shadowOpacity = 0
                if self.direction == .pop { toView.frame = container.bounds }
                ctx.completeTransition(!ctx.transitionWasCancelled)
            }
            animator.startAnimation()
        }

        func runFadeAnimation(ctx: UIViewControllerContextTransitioning,
                              container: UIView,
                              fromView: UIView,
                              toView: UIView,
                              duration: TimeInterval) {
            switch direction {
            case .push:
                container.addSubview(toView)
                toView.alpha = 0
            case .pop:
                container.insertSubview(toView, belowSubview: fromView)
            }

            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
                if self.direction == .push {
                    toView.alpha = 1
                    fromView.alpha = 0.9
                } else {
                    fromView.alpha = 0
                }
            } completion: { _ in
                fromView.alpha = 1
                ctx.completeTransition(!ctx.transitionWasCancelled)
            }
        }

        func runZoomAnimation(ctx: UIViewControllerContextTransitioning,
                              container: UIView,
                              fromView: UIView,
                              toView: UIView,
                              duration: TimeInterval) {
            switch direction {
            case .push:
                container.addSubview(toView)
                toView.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
                toView.alpha = 0
            case .pop:
                container.insertSubview(toView, belowSubview: fromView)
            }

            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
                if self.direction == .push {
                    toView.transform = .identity
                    toView.alpha = 1
                    fromView.alpha = 0.9
                } else {
                    fromView.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
                    fromView.alpha = 0
                }
            } completion: { _ in
                fromView.alpha = 1
                fromView.transform = .identity
                ctx.completeTransition(!ctx.transitionWasCancelled)
            }
        }

        func runFlipAnimation(ctx: UIViewControllerContextTransitioning,
                              container: UIView,
                              fromView: UIView,
                              toView: UIView,
                              duration: TimeInterval) {
            // Avoid UIView.transition(from:to:) because it detaches views and can break nav stack (black screen)
            // Use 3D keyframe rotation with perspective instead.
            let originalSublayerTransform = container.layer.sublayerTransform
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / 600.0
            container.layer.sublayerTransform = perspective
            
            toView.frame = container.bounds
            
            switch direction {
            case .push:
                container.addSubview(toView)
                // Start with new view rotated away
                toView.layer.transform = CATransform3DMakeRotation(-.pi/2, 0, 1, 0)
                
                UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubic], animations: {
                    // 0 -> 50%: rotate old view out
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                        fromView.layer.transform = CATransform3DMakeRotation(.pi/2, 0, 1, 0)
                    }
                    // 50%: swap z-order to reveal new view
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.0) {
                        container.bringSubviewToFront(toView)
                    }
                    // 50% -> 100%: rotate new view in
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        toView.layer.transform = CATransform3DIdentity
                    }
                }, completion: { _ in
                    // Cleanup
                    fromView.layer.transform = CATransform3DIdentity
                    toView.layer.transform = CATransform3DIdentity
                    container.layer.sublayerTransform = originalSublayerTransform
                    ctx.completeTransition(!ctx.transitionWasCancelled)
                })
                
            case .pop:
                // Ensure destination is in the hierarchy behind the fromView
                container.insertSubview(toView, belowSubview: fromView)
                toView.layer.transform = CATransform3DMakeRotation(.pi/2, 0, 1, 0)
                
                UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubic], animations: {
                    // 0 -> 50%: rotate current (top) view out to the left
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                        fromView.layer.transform = CATransform3DMakeRotation(-.pi/2, 0, 1, 0)
                    }
                    // 50% -> 100%: rotate underlying view into place
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        toView.layer.transform = CATransform3DIdentity
                    }
                }, completion: { _ in
                    fromView.layer.transform = CATransform3DIdentity
                    toView.layer.transform = CATransform3DIdentity
                    container.layer.sublayerTransform = originalSublayerTransform
                    ctx.completeTransition(!ctx.transitionWasCancelled)
                })
            }
        }
    }

private extension UIView {
    func addDropShadow(color: UIColor = .black,
                       opacity: Float = 0.18,
                       radius: CGFloat = 10,
                       offset: CGSize = CGSize(width: -2, height: 0)) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
}
