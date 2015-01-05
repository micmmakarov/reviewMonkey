//
//  ViewController.swift
//  YelpReview
//
//  Created by Michael on 12/28/14.
//  Copyright (c) 2014 Michael. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FloatRatingViewDelegate {

    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var generateButton: UIButton!
    var currentBusiness = ""
    
    let pickerData = ["Bar", "Hotel", "DMV"]
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @IBOutlet weak var MonkeyTalkView: UIView!
    @IBOutlet weak var StarFormView: UIView!
    @IBOutlet weak var MonkeyTalk: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")

        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 3
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = false

        self.currentBusiness = pickerData[0]        
        self.BusinessTypeButton.setTitle("\(pickerData[0]) ▼", forState: UIControlState.Normal)
        //self.generateButton.layer.borderColor = self.UIColorFromRGB(0x81451D).CGColor
        //self.generateButton.layer.borderWidth = 2
        //self.generateButton.layer.cornerRadius = 4.0
        self.BusinessTypeButton.tintColor = self.UIColorFromRGB(0xFFFFFF)
        self.BusinessTypeButton.backgroundColor = self.UIColorFromRGB(0xFBE0C3)

        
        self.generateButton.layer.borderColor = self.UIColorFromRGB(0x81451D).CGColor
        self.generateButton.layer.borderWidth = 2
        self.generateButton.layer.cornerRadius = 4.0
        self.generateButton.tintColor = self.UIColorFromRGB(0x81451D)
        //self.generateButton.backgroundColor = UIColor.blueColor()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()

        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if screenHeight == 480 {
            self.chooseBusinessLabel.hidden = true
            self.grayComment.hidden = true
        }
        
        

    }

    @IBOutlet weak var chooseBusinessLabel: UILabel!
    @IBOutlet weak var BusinessTypeButton: UIButton!
    @IBOutlet weak var grayComment: UILabel!
    @IBAction func chooseBusinessType(sender: AnyObject) {
        
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "Business Type", message: "Choose a business type", preferredStyle: .ActionSheet)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)

            for business: String in pickerData {
                let businessTypeOption: UIAlertAction = UIAlertAction(title: business, style: .Default) { action -> Void in
                    self.currentBusiness = business
                    self.BusinessTypeButton.setTitle("\(business) ▼", forState: UIControlState.Normal)
                    let title = "\(business) ▼"
                    let myNormalAttributedTitle = NSMutableAttributedString(string: title,
                        attributes: nil)
                    myNormalAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "Helvetica", size: 26.0)!, range: NSRange(location:1, length:countElements(title) - 1))
                    myNormalAttributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "Helvetica", size: 14.0)!, range: NSRange(location:countElements(title) - 1, length:1))
                    
                    self.BusinessTypeButton.setAttributedTitle(myNormalAttributedTitle, forState: .Normal)
                    //Code for launching the camera goes here
                }
                actionSheetController.addAction(businessTypeOption)
            }
            //Create and add first option action
            //Create and add a second option action
        
            //We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = sender as UIView;
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        
        
    }
    @IBAction func generate(sender: AnyObject) {
        let view = self.storyboard?.instantiateViewControllerWithIdentifier("result") as resultViewController
        //view.navigationController = self.navigationController
        view.generate(Int(self.floatRatingView.rating), business: self.currentBusiness)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        // self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating)
    }
}

