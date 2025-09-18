
# 🚀 DNPushAnimation
A lightweight, UIKit-first custom transition engine for UINavigationController
with creative push/pop animations + interactive edge-swipe to pop.

Forget boring slides — make your navigation feel alive ✨
## ✨ Features

- 🎬 Multiple animation styles
    Choose from: slide, fade, zoom, flip, card, drawer, scaleUp, dissolve or build your own with .custom

- 🎛 Highly configurable
    Tweak duration, damping, parallax, shadows, card corner radius, drawer width, dissolve blur, and more.

- 👆 Interactive edge-swipe pop
    Just like iOS, but works with all custom animations.

- 🧩 Swift Package Manager ready
    Plug it into your app with 2 clicks.


## Installation

Xcode

- File → Add Package → Paste URL of this repo

Or add to Package.swift

```swift
.package(url: "https://github.com/dickysuryos/DNPushAnimation.git", from: "1.0.0")
```
Then depend on it:
```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "PushAnimator", package: "PushAnimator")
    ]
)
```
## 🚦 Quick Start

UIKit
```swift
import Component from 'my-project'

import DNPushAnimation

final class RootVC: UIViewController {
    private var navTrans: NavigationTransitionController?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if navTrans == nil, let nav = navigationController {
            navTrans = nav.usePushAnimator(
                animationType: .card,
                options: .init(duration: 0.5, cardCornerRadius: 24),
                interactivePop: true
            )
        }
    }
}
```

SwiftUI
```swift
import SwiftUI
import DNPushAnimation

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationControllerHost { UIHostingController(rootView: ContentView()) }
        }
    }
}
```

## 🎨 Animation Styles

| Type             | Preview Idea                                                                |
| ----------------- | ------------------------------------------------------------------ |
| .slide | Classic iOS-style push with parallax + shadow |
| .fade | Cross-fade between view controllers |
| .zoom| Zoom-in/zoom-out effect |
| .flip| 3D card flip with perspective |
| .card| Push up from bottom, spring bounce, rounded corners |
|.drawer|	Slide in from right like a side drawer |
|.scaleUp|	Scale from 0.9 → 1.0|
|.dissolve	|Old view blurs & fades into the new|

## 💡 Notes

Keep a strong reference to NavigationTransitionController (property on root VC / SceneDelegate / SwiftUI Coordinator).

Safe with interactive gestures. Cancelled pushes clean up gracefully.

iOS 13+ support.

## Screenshots
| Slide          | Dissolve                                                               | Flip |
| ----------------- | ------------------------------------------------------------------ |---------- |
| ![App Screenshot](https://download.psvitamampang.com/api/public/dl/bppW1uI4?inline=true) | ![App Screenshot](https://download.psvitamampang.com/api/public/dl/Wu8rJL3g?inline=true) | ![App Screenshot](https://download.psvitamampang.com/api/public/dl/ntR9Nwn8?inline=true) |
