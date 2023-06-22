//
//  UIView+Border.swift
//  Map Storyboard
//
//  Created by DB-MM-011 on 20/06/23.
//

import Foundation
import UIKit

extension UIView {
    func addFullBorder(color: UIColor, width: CGFloat, cornerRadius: CGFloat) {
        let topBorder = CALayer()
        topBorder.backgroundColor = color.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
        
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = color.cgColor
        bottomBorder.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
        
        let leftBorder = CALayer()
        leftBorder.backgroundColor = color.cgColor
        leftBorder.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        
        let rightBorder = CALayer()
        rightBorder.backgroundColor = color.cgColor
        rightBorder.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
        
        let roundedCornersLayer = CAShapeLayer()
        roundedCornersLayer.fillColor = UIColor.clear.cgColor
        roundedCornersLayer.strokeColor = color.cgColor
        roundedCornersLayer.lineWidth = width
        roundedCornersLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        
        self.layer.addSublayer(topBorder)
        self.layer.addSublayer(bottomBorder)
        self.layer.addSublayer(leftBorder)
        self.layer.addSublayer(rightBorder)
        self.layer.addSublayer(roundedCornersLayer)
    }
}
