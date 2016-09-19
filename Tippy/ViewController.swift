//
//  ViewController.swift
//  Tippy
//
//  Created by Daniel Lin on 7/16/16.
//  Copyright (c) 2016 Daniel Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var roundUp: UISwitch!
    let tipPercentages = [0.10, 0.15, 0.2]
    @IBOutlet weak var block: UIView!
    var originalY = 0.0
    
    // From: https://guides.codepath.com/ios/Using-Perspective-Transforms#step-4-animating-the-transform
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    // OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // GRADIENT
        // From: https://www.youtube.com/watch?v=pabNgxzEaRk
        let topColor = UIColor(red:(15/255.0), green: (118/255.0), blue:(128/255.0),alpha:1)
        let bottomColor = UIColor(red:(84/255.0), green: (187/187), blue:(187/255.0),alpha:1)
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPointMake(0.0, 0.0)
        gradientLayer.endPoint = CGPointMake(1.0, 1.0)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, atIndex:0)
        
        // Edit BillField
        billField.becomeFirstResponder()
        billField.attributedPlaceholder = NSAttributedString(string:"Subtotal       $", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        //print(billField.frame.minY)
        originalY = Double(billField.frame.minY)
        
        
        // Set Anchor Point
        setAnchorPoint(CGPoint(x: 0.5, y: 1.0), forView: block)
        
        // Edit Block
        block.layer.cornerRadius = 10;
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / 500.0
        transform = CATransform3DRotate(transform, CGFloat(90 * M_PI / 180 * -1), 1, 0, 0)
        block.layer.transform = transform


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // IBACTION
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    @IBAction func roundUp_Toggled(sender: UISwitch) {
        calculateTip(self)
    }
    @IBAction func changeTip(sender: AnyObject) {
        calculateTip(self)
    }
    
    // 09/19
    // Takes in a string (from shortcutItem.type), and is either a 10,15,or 20. This will set the tipControl (UISegmentedControl) active index
    func setTipString(tipString: String)
    {
        if tipString == "10"
        {
            tipControl.selectedSegmentIndex = 0
        }
        else if tipString == "15"
        {
            tipControl.selectedSegmentIndex = 1
        }
        else if tipString == "20"
        {
            tipControl.selectedSegmentIndex = 2
        }
        
    }
    
    @IBAction func calculateTip(sender: AnyObject) {
        
        let bill           = Double(billField.text!) ?? 0
        let activeIndex    = tipControl.selectedSegmentIndex
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / 500.0


        if(bill == 0){
            let yTarget = originalY


            
            // ANIMATE EMPTY STATE
            UIView.animateWithDuration(0.3, animations: {
                self.block.alpha = 1
                self.billField.frame = CGRect(x: 30.0, y: yTarget, width: 320.0, height: 52.0)

                
            })
            


            transform = CATransform3DRotate(transform, CGFloat(90 * M_PI / 180 * -1), 1, 0, 0)
            let animation = CABasicAnimation(keyPath: "transform")
            animation.toValue = NSValue(CATransform3D:transform)
            animation.duration = 0.25
            

            
            block.layer.addAnimation(animation, forKey: "transform")
            runAfterDelay(animation.duration - 0.05 ) {
                self.block.layer.transform = transform
            }

        }
        else{
            let yTarget = originalY - 120
            
            // ANIMATE CALCULATING STATE
            UIView.animateWithDuration(0.3, animations: {
                self.block.alpha = 1
                self.billField.frame = CGRect(x: 30.0, y: yTarget, width: 320.0, height: 52.0)


            })
            
            transform = CATransform3DRotate(transform, CGFloat(0 * M_PI / 180 * -1), 1, 0, 0)
            let animation = CABasicAnimation(keyPath: "transform")
            animation.toValue = NSValue(CATransform3D:transform)
            animation.duration = 0.3
            block.layer.addAnimation(animation, forKey: "transform")
            
            runAfterDelay(animation.duration - 0.05) {
                self.block.layer.transform = transform
            }

            

        }
        
        ///// CALCULATE TIP  /////
        if(roundUp.on == true){
            for (index, value) in tipPercentages.enumerate() {
                
                ///// SEGMENTED CONTROL LABELS /////
                let tip   = bill * value
                let total = bill + tip

                let rounded_total   = ceil(total)
                let rounded_tip     = tip + (rounded_total - total)
                let rounded_percent = rounded_tip * 100 / bill;
                let rounded_label   = String(format: "%.2f%%", rounded_percent)
                
                tipControl.setTitle(rounded_label, forSegmentAtIndex: index)
                
                if (bill == 0){
                    ///// DEFAULT LABELS /////
                    let tip_label = String(format: "+ %.0f%%", value * 100)
                    tipControl.setTitle(tip_label, forSegmentAtIndex: index)
                }
                
                ///// ACTIVE TIP LABELS /////
                if index == activeIndex{
                    tipLabel.text   = String(format: "+ $%.2f", rounded_tip)
                    totalLabel.text = String(format: "$%.2f", rounded_total)
                    
                }
            }
        }
        else {
            for (index, value) in tipPercentages.enumerate() {
                
                ///// SEGMENTED CONTROL LABELS /////
                let tip_label = String(format: "%.0f%%", value * 100)
                tipControl.setTitle(tip_label, forSegmentAtIndex: index)
                
                ///// ACTIVE TIP LABELS /////
                if index == activeIndex{
                    let tip   = bill * value
                    let total = bill + tip
                    
                    tipLabel.text   = String(format: "+ $%.2f", tip)
                    totalLabel.text = String(format: "$%.2f", total)
                }
            }
        }
    }
    
    
}

