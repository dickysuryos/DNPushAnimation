    //
    //  PushAnimator.swift
    //  DNPushAnimation
    //
    //  Created by dicky suryo on 15/09/25.
    //

    import UIKit

public final class PushAnimator: NSObject {
    public struct Options: Sendable {
    // Core
    public var duration: TimeInterval
    public var dampingRatio: CGFloat
    public var parallax: CGFloat
    public var addsShadow: Bool
    public var scaleOnPush: CGFloat
        
    // Drawer
    public var drawerWidthRatio: CGFloat // 0.6...1.0; portion of screen width
    public var drawerDimOpacity: CGFloat // 0.0...1.0; background dim behind drawer

    // Card
    public var cardCornerRadius: CGFloat
    public var cardSpringDamping: CGFloat
    public var cardSpringVelocity: CGFloat

    // ScaleUp
    public var scaleUpInitialScale: CGFloat // 0.7...1.0

    // Dissolve
    public var blurOnDissolve: Bool
    public var dissolveFromAlpha: CGFloat // starting alpha for incoming view on push
        
    public init(duration: TimeInterval = 0.36,
                dampingRatio: CGFloat = 0.92,
                parallax: CGFloat = 0.25,
                addsShadow: Bool = true,
                scaleOnPush: CGFloat = 0.98,
                drawerWidthRatio: CGFloat = 0.8,
                drawerDimOpacity: CGFloat = 0.2,
                cardCornerRadius: CGFloat = 20,
                cardSpringDamping: CGFloat = 0.85,
                cardSpringVelocity: CGFloat = 0.8,
                scaleUpInitialScale: CGFloat = 0.9,
                blurOnDissolve: Bool = true,
                dissolveFromAlpha: CGFloat = 0.0) {
        self.duration = duration
        self.dampingRatio = dampingRatio
        self.parallax = parallax
        self.addsShadow = addsShadow
        self.scaleOnPush = scaleOnPush
        self.drawerWidthRatio = drawerWidthRatio
        self.drawerDimOpacity = drawerDimOpacity
        self.cardCornerRadius = cardCornerRadius
        self.cardSpringDamping = cardSpringDamping
        self.cardSpringVelocity = cardSpringVelocity
        self.scaleUpInitialScale = scaleUpInitialScale
        self.blurOnDissolve = blurOnDissolve
        self.dissolveFromAlpha = dissolveFromAlpha
        }
    }


    public enum Direction { case push, pop }


    public let type: PushAnimationType
    public let direction: Direction
    public let options: Options


    public init(type: PushAnimationType = .slide,
    direction: Direction,
    options: Options = .init()) {
    self.type = type
    self.direction = direction
    self.options = options
    super.init()
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
