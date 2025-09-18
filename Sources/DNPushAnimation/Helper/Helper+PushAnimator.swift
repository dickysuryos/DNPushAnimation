//
//  Helper+PushAnimator.swift
//  DNPushAnimation
//
//  Created by dicky suryo on 18/09/25.
//
import UIKit
import Foundation

public extension PushAnimator {
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
