//
//  CardView.swift
//  SelecorViewDemo
//
//  Created by Calvin Chang on 14/03/2018.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit

class CardView: UIView {

    internal var gradient = CAGradientLayer()
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }
    
    //MARK:- Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureCardView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCardView()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        configureCardView()
    }
    
    fileprivate func configureCardView() {
        layer.insertSublayer(gradient, at: 0)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
    }
    
}
