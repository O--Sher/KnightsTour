//
//  UIViewController+Embeding.swift
//  MedUX Agent
//
//  Created by Oleg Sher on 27.03.17.
//  Copyright © 2017 MedUX. All rights reserved.
//

import UIKit

extension UIViewController {
    func embedViewController(_ childVC: UIViewController, inView containerView: UIView) {
        self.addChildViewController(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.embed(onView: containerView)
        childVC.didMove(toParentViewController: self)
    }
}
