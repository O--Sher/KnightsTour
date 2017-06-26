//
//  UIView+Embeding.swift
//  MedUX Agent
//
//  Created by Oleg Sher on 27.02.17.
//  Copyright © 2017 MedUX. All rights reserved.
//

import UIKit

extension UIView {
    func embed(onView containerView: UIView, offset: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: offset).isActive = true
        self.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: offset).isActive = true
        self.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: offset).isActive = true
        self.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: offset).isActive = true
        containerView.layoutIfNeeded()
    }
}
