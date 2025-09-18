//
//  ViewController.swift
//  PushAnimationExample
//
//  Created by dicky suryo on 16/09/25.
//

import UIKit
import DNPushAnimation
class ViewController: UIViewController {
    private var navTrans: NavigationTransitionController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        if navTrans == nil, let nav = navigationController {
                    navTrans = nav.usePushAnimator(
                        animationType: .slide, // 👈 choose .slide, .fade, .zoom
                        options: .init(duration: 1, dampingRatio: 0.9, parallax: 0.3),
                        interactivePop: true
                )
            }
        self.view.backgroundColor = .blue
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Push Next", for: .normal)
        button.addTarget(self, action: #selector(pushNext), for: .touchUpInside)
        button.sizeToFit()
        button.center = view.center
        button.isUserInteractionEnabled = true
        view.addSubview(button)
    }
    
    @objc private func pushNext() {
        let next = UIViewController()
        next.view.backgroundColor = .red
        let title = UILabel(frame: .init(x: 0, y: 0, width: 500, height: 21))
        title.text = "ViewController 2"
        title.center = next.view.center
        title.textColor = .white
        title.textAlignment = .center
        next.view.addSubview(title)
        navigationController?.pushViewController(next, animated: true)
    }


}

