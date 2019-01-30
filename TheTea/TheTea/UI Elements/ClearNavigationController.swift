//
//  ClearNavigationController.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/28/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class ClearNavigationController: UINavigationController, UINavigationControllerDelegate {
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let gradientLayer = CAGradientLayer()
    let backgroundImageView = UIImageView(image: UIImage(named: "placeholderBackground"))
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effectView.frame =  (self.navigationBar.bounds.insetBy(dx: 0, dy: -24).offsetBy(dx: 0, dy: -24))
        self.navigationBar.isTranslucent = true
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.addSubview(effectView)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.navTitle() as Any,
                                                 NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationBar.sendSubviewToBack(effectView)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
        gradientLayer.colors = [
            UIColor(red:0.94, green:0.53, blue:1, alpha:0.9).cgColor,
            UIColor(red:0.47, green:0.77, blue:1, alpha:0.9).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundImageView.layer.addSublayer(gradientLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationBar.sendSubviewToBack(effectView)
        
        view.sendSubviewToBack(backgroundImageView)
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        StyleManager.setWhiteNavBarStyling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        StyleManager.updateNavBarStyling()
    }
}

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var presenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let container = transitionContext.containerView
        if presenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        let toViewFrame = toView.frame
        toView.frame = CGRect(x: presenting ? toView.frame.width : -toView.frame.width, y: toView.frame.origin.y, width: toView.frame.width, height: toView.frame.height)
        
        let animations = {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                toView.alpha = 1
                if self.presenting {
                    fromView.alpha = 0
                }
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                toView.frame = toViewFrame
                fromView.frame = CGRect(x: self.presenting ? -fromView.frame.width : fromView.frame.width, y: fromView.frame.origin.y, width: fromView.frame.width, height: fromView.frame.height)
                if !self.presenting {
                    fromView.alpha = 0
                }
            }
            
        }
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: animations,
                                completion: { finished in
                                    // 8
                                    container.addSubview(toView)
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
