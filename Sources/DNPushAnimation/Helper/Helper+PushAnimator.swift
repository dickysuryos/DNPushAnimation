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
        toView.alpha = (direction == .push) ? 0 : 1

        var blurView: UIVisualEffectView?
        if options.blurOnDissolve {
            let blur = UIBlurEffect(style: .systemMaterial)
            let bv = UIVisualEffectView(effect: nil)
            bv.frame = fromView.bounds
            fromView.addSubview(bv)
            blurView = bv
            UIView.animate(withDuration: duration * 0.8) { bv.effect = blur }
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
            toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            toView.alpha = 0
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
                fromView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
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
        switch direction {
        case .push:
        container.addSubview(toView)
        toView.frame = CGRect(x: width, y: 0, width: drawerWidth, height: height)
        let dim = UIView(frame: container.bounds)
        dim.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        dim.tag = 9991
        container.insertSubview(dim, belowSubview: toView)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
        toView.frame.origin.x = width - drawerWidth
        dim.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        fromView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        } completion: { _ in
        ctx.completeTransition(!ctx.transitionWasCancelled)
        }
        case .pop:
        let dim = container.viewWithTag(9991)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
        fromView.frame.origin.x = width
        dim?.backgroundColor = UIColor.black.withAlphaComponent(0.0)
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
                                  duration: TimeInterval) {
        if direction == .push {
            container.addSubview(toView)
            toView.frame = CGRect(x: 0, y: container.bounds.height,
                                  width: container.bounds.width,
                                  height: container.bounds.height)
            toView.layer.cornerRadius = 20
            toView.clipsToBounds = true

            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 0.85,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseOut) {
                toView.frame = container.bounds
            } completion: { finished in
                toView.layer.cornerRadius = 0
                ctx.completeTransition(finished && !ctx.transitionWasCancelled)
            }
        } else {
            UIView.animate(withDuration: duration, animations: {
                fromView.frame.origin.y = container.bounds.height
            }) { finished in
                ctx.completeTransition(finished && !ctx.transitionWasCancelled)
            }
        }
    }
     func runFlipAnimation(ctx: UIViewControllerContextTransitioning,
                                  container: UIView,
                                  fromView: UIView,
                                  toView: UIView,
                                  duration: TimeInterval) {
        let opts: UIView.AnimationOptions = (direction == .push) ? .transitionFlipFromRight : .transitionFlipFromLeft
        UIView.transition(from: fromView,
                          to: toView,
                          duration: duration,
                          options: [opts, .showHideTransitionViews]) { finished in
            ctx.completeTransition(finished && !ctx.transitionWasCancelled)
        }
    }
    
     func runSlideAnimation(ctx: UIViewControllerContextTransitioning,
                                   container: UIView,
                                   fromView: UIView,
                                   toView: UIView,
                                   width: CGFloat,
                                   height: CGFloat,
                                   duration: TimeInterval) {
        if direction == .push {
            container.addSubview(toView)
            toView.frame = CGRect(x: width, y: 0, width: width, height: height)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        let parallaxOffset = width * options.parallax
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
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
        animator.startAnimation()
    }
    
    func runFadeAnimation(ctx: UIViewControllerContextTransitioning,
                                  container: UIView,
                                  fromView: UIView,
                                  toView: UIView,
                                  duration: TimeInterval) {
        if direction == .push {
            container.addSubview(toView)
            toView.alpha = 0
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        UIView.animate(withDuration: duration, animations: {
            if self.direction == .push {
                toView.alpha = 1
            } else {
                fromView.alpha = 0
            }
        }, completion: { finished in
            fromView.alpha = 1
            ctx.completeTransition(finished && !ctx.transitionWasCancelled)
        })
    }
    
    func runZoomAnimation(ctx: UIViewControllerContextTransitioning,
                                  container: UIView,
                                  fromView: UIView,
                                  toView: UIView,
                                  duration: TimeInterval) {
        if direction == .push {
            container.addSubview(toView)
            toView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            toView.alpha = 0
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            if self.direction == .push {
                toView.transform = .identity
                toView.alpha = 1
                fromView.alpha = 0.8
            } else {
                fromView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                fromView.alpha = 0
            }
        }, completion: { finished in
            fromView.alpha = 1
            fromView.transform = .identity
            ctx.completeTransition(finished && !ctx.transitionWasCancelled)
        })
    }
}
