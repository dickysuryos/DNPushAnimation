//
//  AnimationType.swift
//  DNPushAnimation
//
//  Created by dicky suryo on 18/09/25.
//

import UIKit

public enum PushAnimationType {
    case slide  // current parallax slide
    case fade   // cross-fade between VCs
    case zoom   // zoom- in/out effect
    case flip         // 3D flip (like turning a card)
    case card         // “card push” – new VC rises from the bottom with rounded corners
    case drawer       // slide from the right like a drawer
    case scaleUp      // new VC grows from center
    case dissolve     // old VC dissolves into the new one
    case custom((UIViewControllerContextTransitioning) -> Void)
    // add more here
}

