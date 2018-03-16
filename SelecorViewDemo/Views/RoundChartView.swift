//
//  RoundChartView.swift
//  SelecorViewDemo
//
//  Created by Calvin Chang on 14/03/2018.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit



class RoundChartView: UIView {

    // MARK:- Public Properties
    public var chartThickness: CGFloat = 0 {
        didSet {
            greyChart.lineWidth = chartThickness
            colorChart.lineWidth = chartThickness
        }
    }
    
    public var chartColor: UIColor {
        set {
            colorChart.strokeColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor:colorChart.strokeColor!)
        }
    }
    
    let easeOut = CAMediaTimingFunction(controlPoints: 0, 0.4, 0.4, 1)
    
    // MARK:- Private Properties
    fileprivate let greyChart: CAShapeLayer = {
        let circle: CAShapeLayer = CAShapeLayer()
        circle.position = .zero
        circle.lineCap = kCALineCapRound
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        circle.strokeEnd = 0
        return circle
    }()
    
    fileprivate let colorChart: CAShapeLayer = {
        let circle: CAShapeLayer = CAShapeLayer()
        circle.position = .zero
        circle.lineCap = kCALineCapRound
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeEnd = 0
        circle.strokeColor = UIColor.red.cgColor
        return circle
    }()
    
    // MARK:- Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureChartView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureChartView()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        configureChartView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path: CGPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.size.width / 2).cgPath
        colorChart.path = path
        greyChart.path = path
    }
    
    fileprivate func configureChartView() {
        layer.addSublayer(greyChart)
        layer.addSublayer(colorChart)
    }
    
    // MARK:- Public Method
    open func show(percentage: Int, delay: TimeInterval = 0) {
        let showTime: TimeInterval = 0.8
        
        let colorChartShow = animation(percentage: percentage, duration: 0.6, timingFunction: easeOut)
        colorChartShow.beginTime = delay
        
        let colorGroup: CAAnimationGroup = CAAnimationGroup()
        colorGroup.duration = delay + colorChartShow.duration + showTime
        colorGroup.animations = [colorChartShow]
        colorGroup.fillMode = kCAFillModeForwards
        colorGroup.isRemovedOnCompletion = false
        
        colorChart.add(colorGroup, forKey: "show")
        
        let greyChartShow = animation(percentage: 100, duration: 0.6, timingFunction:easeOut)
        greyChartShow.beginTime = colorChartShow.beginTime
        
        let greyGroup: CAAnimationGroup = CAAnimationGroup()
        greyGroup.animations = [greyChartShow]
        greyGroup.duration = colorGroup.duration
        greyGroup.fillMode = kCAFillModeForwards
        greyGroup.isRemovedOnCompletion = false
        
        greyChart.add(greyGroup, forKey: "show")
    }
    
    open func reset () {
        colorChart.removeAllAnimations()
        greyChart.removeAllAnimations()
    }
    
    fileprivate func animation(percentage: Int, duration: TimeInterval, timingFunction:CAMediaTimingFunction) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.duration = duration
        animation.repeatCount = 1
        animation.toValue = Float(percentage) / 100
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = timingFunction
        
        return animation
    }

}
