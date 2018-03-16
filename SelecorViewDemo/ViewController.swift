//
//  ViewController.swift
//  SelecorViewDemo
//
//  Created by Calvin Chang on 13/03/2018.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var selectorView: SelectorView!
    
    @IBOutlet fileprivate weak var firstChartView: RoundChartView!

    @IBOutlet fileprivate weak var secondChartView: RoundChartView!
    
    @IBOutlet fileprivate weak var firstPercentLabel: UILabel!
    
    @IBOutlet fileprivate weak var secondPercentLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var chartContainerView: UIView!
    
    @IBOutlet weak var optionTableTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var optionTableViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var optionTableView: UITableView!
    
    fileprivate var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeUpAction(sender:)))
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard selectorView != nil else {
            return .default
        }

        if selectorView.isSelected {
            return .lightContent
        }
        else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureSelectorView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chartViewReload(index: 0)
    }

    func configureSelectorView() {
        view.backgroundColor = UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        
        selectorView.selectViews = createCardViews(numberOfCards: 5)
        
        firstChartView.chartThickness = 10
        firstChartView.chartColor = UIColor.init(red: 86/255, green: 189/255, blue: 166/255, alpha: 1)

        secondChartView.chartThickness = 10
        secondChartView.chartColor = UIColor.init(red: 86/255, green: 189/255, blue: 166/255, alpha: 1)
        
        selectorView.delegate = self
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOffset = CGSize(width: 1, height: -2)
        contentView.layer.shadowOpacity = 0.3
        
        optionTableView.delegate = self
        optionTableView.dataSource = self
        optionTableView.register(UINib.init(nibName: "OptionCell", bundle: nil), forCellReuseIdentifier: "OptionCellIdentifier")
        optionTableView.isUserInteractionEnabled = selectorView.isSelected
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeUpAction(sender:)))
        swipeGesture.direction = .up;
        contentView.addGestureRecognizer(swipeGesture)
    }
    
    @objc func swipeUpAction(sender : UISwipeGestureRecognizer) {
        self.selectorView.carousel(self.selectorView.carouselView, didSelectItemAt: self.selectorView.carouselView.currentItemIndex)
        animateTable()
    }
    
    func createCardViews(numberOfCards : Int) -> Array<CardView> {
        var views = [CardView]()
        for index in 0..<numberOfCards {
            let card = CardView(frame: CGRect(x: 0, y: 0, width: view.bounds.width - 50, height: 180))

            let label = UILabel()
            card.addSubview(label)
            
            label.text = "\(index)"
            label.textColor = UIColor.white
            label.snp.makeConstraints({ (make) in
                make.center.equalTo(card)
            })
            
            card.gradient.colors = [UIColor.init(red: 46/255, green: 34/255, blue: 150/255, alpha: 1).cgColor, UIColor.init(red: 156/255, green: 76/255, blue: 239/255, alpha: 1).cgColor]
            card.gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            card.gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            card.gradient.cornerRadius = 8

            views.append(card)
        }
        return views
    }
    
    func animateTable() {
        optionTableView.reloadData()
        let cells = optionTableView.visibleCells
        
        var index = 0
        for cell:UITableViewCell in cells {
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(index), options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 20)
            }, completion: nil)
        }
        
        index = 0
        for cell:UITableViewCell in cells {
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index) + 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            index += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : SelectorViewDelegate {
    
    func selectorView(selectorView: SelectorView, cardSelectAtIndex index: Int, isSelected: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            if !isSelected {
                self.optionTableTopConstraint.constant = 240
                self.optionTableViewBottomConstraint.constant = -190
                self.chartContainerView.alpha = 1
            }
            else {
                self.optionTableTopConstraint.constant = 50
                self.optionTableViewBottomConstraint.constant = 0
                self.chartContainerView.alpha = 0
            }
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.transitionCurlUp,.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        optionTableView.isUserInteractionEnabled = isSelected
        if !isSelected {
            chartViewReload(index: index)
        }
    }
    
    func selectorView(selectorView: SelectorView, cardMoveToIndex index: Int, isSelected: Bool) {
        if !isSelected {
            chartViewReload(index: index)
        }
    }
    
    func chartViewReload(index : Int) {
        firstChartView.reset()
        secondChartView.reset()
        firstChartView.show(percentage: 10 * (index + 1))
        firstPercentLabel.animationFrom(value: 0, toValue: 10 * (index + 1), delay: 0, stringPrefix: "", stringPostfix: "%")
        secondChartView.show(percentage: 12 * (index + 1), delay: 1)
        secondPercentLabel.animationFrom(value: 0, toValue: 12 * (index + 1), delay: 1, stringPrefix: "", stringPostfix: "%")
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optionCell: OptionCell = tableView.dequeueReusableCell(withIdentifier: "OptionCellIdentifier", for: indexPath) as! OptionCell
        optionCell.transform = CGAffineTransform.identity
        return optionCell
    }
    
    
}
