//
//  ViewController.swift
//  PushAnimationExample
//
//  Created by dicky suryo on 16/09/25.
//

import UIKit
import DNPushAnimation
class ViewController: UIViewController {
    private var navTransitionController: NavigationTransitionController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        if let nav = navigationController {
        navTransitionController = nav.usePushAnimator(
        options: .init(duration: 0.4, dampingRatio: 0.9, parallax: 0.28, addsShadow: true, scaleOnPush: 0.98),
        interactivePop: true
            )
        }
        
        let button = UIButton(type: .system)
        button.setTitle("Push Next", for: .normal)
//        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushNext)))
        button.addTarget(self, action: #selector(pushNext), for: .touchUpInside)
        button.sizeToFit()
        button.center = view.center
        button.isUserInteractionEnabled = true
        view.addSubview(button)
    }
    
    @objc private func pushNext() {
        let next = UIViewController()
        next.view.backgroundColor = .systemGroupedBackground
        navigationController?.pushViewController(next, animated: true)
    }


}

