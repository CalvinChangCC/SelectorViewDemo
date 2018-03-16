//
//  SelectorView.swift
//  SelecorViewDemo
//
//  Created by Calvin Chang on 13/03/2018.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit
import iCarousel

protocol SelectorViewDelegate: NSObjectProtocol {
    
    func selectorView(selectorView:SelectorView, cardSelectAtIndex index:Int, isSelected:Bool)
    func selectorView(selectorView:SelectorView, cardMoveToIndex index:Int, isSelected:Bool)
}

class SelectorView: UIView, iCarouselDelegate, iCarouselDataSource {
    
    //MARK:- Public Properties
    public var selectViews = Array<CardView>() {
        didSet {
            pageControl.numberOfPages = selectViews.count
            layoutIfNeeded()
            carouselView.reloadData()
        }
    }
    
    public weak var delegate:SelectorViewDelegate?
    
    //MARK:- Private Properties
    fileprivate var heightConstraint = NSLayoutConstraint()
    
    fileprivate lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.init(red: 86/255, green: 189/255, blue: 166/255, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        pageControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        return pageControl;
    }()
    
    private(set) lazy var carouselView : iCarousel = {
        let carouselView = iCarousel()
        carouselView.dataSource = self
        carouselView.delegate = self
        carouselView.type = .coverFlow2
        carouselView.isPagingEnabled = true
        
        return carouselView
    }()
    
    internal var isSelected = false {
        didSet {
            self.configureCards()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSelectorView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelectorView()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        configureSelectorView()
    }
    
    func configureSelectorView() {
        self.addSubview(pageControl)
        self.addSubview(carouselView)
        backgroundColor = UIColor.clear
        
        for layoutConstraint: NSLayoutConstraint in constraints {
            if layoutConstraint.identifier == "height" {
                heightConstraint = layoutConstraint
                break
            }
        }
    }
    
    func configureCards() {
        if isSelected {
            for cardView : CardView in self.selectViews {
                heightConstraint.constant = 130
                cardView.frame = CGRect(x: -35, y: 15, width: carouselView.bounds.width, height: self.bounds.height + 20)
                cardView.gradient.cornerRadius = 0
                cardView.layer.shadowOpacity = 0
                carouselView.type = .timeMachine
                
                pageControl.alpha = 0
            }
        }
        else {
            for cardView : CardView in self.selectViews {
                heightConstraint.constant = 200
                cardView .frame = CGRect(x: 10, y: 0, width: carouselView.bounds.width - 90, height: carouselView.bounds.height - 10)
                cardView.gradient.cornerRadius = 8
                cardView.layer.shadowOpacity = 0.5
                carouselView.type = .coverFlow2
                
                pageControl.alpha = 1
            }
        }
    }

    //MARK:- Lift Cycle
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil else {
            return
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        carouselView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - 20)
        pageControl.frame = CGRect(x: 0, y: bounds.height - 20, width: bounds.width, height: 10)
        configureCards()
    }
    
    //MARK:- iCarouselDataSource
    func numberOfItems(in carousel: iCarousel) -> Int {
        return selectViews.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var frameView:UIView?
        if view == nil {
            frameView = UIView(frame: CGRect(x: 0, y: 0, width: carousel.bounds.width - 70, height: carousel.bounds.height))
            frameView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        else {
            frameView = view
            for subview:UIView in (frameView?.subviews)! {
                subview.removeFromSuperview()
            }
        }
        let itemView = selectViews[index]
        frameView?.addSubview(itemView)
        
        return frameView!
    }
    
    //MARK:- iCarouselDelegate
    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        if isSelected {
            return carousel.bounds.width
        }
        else {
            return carousel.bounds.width - 70
        }
    }

    func carouselDidScroll(_ carousel: iCarousel) {
        if selectViews.count != 0 {
            pageControl.currentPage = carouselView.currentItemIndex
        }
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: {
            self.isSelected = !self.isSelected
            self.superview?.layoutIfNeeded()
        }) { (finish) in
            if finish {
                self.delegate?.selectorView(selectorView: self, cardSelectAtIndex: index, isSelected: self.isSelected)
            }
        }
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        delegate?.selectorView(selectorView: self, cardMoveToIndex: carousel.currentItemIndex, isSelected: isSelected)
    }
}
