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
    public var drawerWidthRatio: CGFloat // used by .drawer (0.6...1.0)
    public var blurOnDissolve: Bool // used by .dissolve

    public init(duration: TimeInterval = 0.36,
                dampingRatio: CGFloat = 0.92,
                parallax: CGFloat = 0.25,
                addsShadow: Bool = true,
                scaleOnPush: CGFloat = 0.98,
                drawerWidthRatio: CGFloat = 0.8,
                blurOnDissolve: Bool = true) {
        self.duration = duration
        self.dampingRatio = dampingRatio
        self.parallax = parallax
        self.addsShadow = addsShadow
        self.scaleOnPush = scaleOnPush
        self.drawerWidthRatio = drawerWidthRatio
        self.blurOnDissolve = blurOnDissolve
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
