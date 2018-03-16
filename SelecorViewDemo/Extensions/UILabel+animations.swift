//
//  UILabel+animations.swift
//  SelecorViewDemo
//
//  Created by Calvin Chang on 14/03/2018.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit

extension UILabel {
    func animationFrom(value:Int = 0, toValue:Int, delay:TimeInterval = 0, stringPrefix:String = "", stringPostfix:String = "") {
        guard toValue >= value else {
            self.text = "\(stringPrefix)\(value)\(stringPostfix)"
            return
        }

        let timeInterval : TimeInterval =  Double(1.00/Double(toValue - value))
        
        var startValue = value
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] (timer) in
                self?.text = "\(stringPrefix)\(startValue)\(stringPostfix)"
                startValue += 1
                
                if startValue > toValue {
                    timer.invalidate()
                }
            }
        }
        
        
    }
}
