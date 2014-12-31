//
//  resultViewController.swift
//  YelpReview
//
//  Created by Michael on 12/28/14.
//  Copyright (c) 2014 Michael. All rights reserved.
//

import UIKit

class resultViewController: UIViewController, FloatRatingViewDelegate {
    
    var stars: Int = 0;
    var business: String = "";
    var initialized = false;
    
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var businessType: UILabel!
    //@IBOutlet weak var stars: UILabel!
    @IBOutlet weak var resultText: UITextView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var resultContainer: UIView!

    // Main API call
    func getRating(stars: Int, business: String, completion: (rating: String) -> Void) {
        var url = NSURL(string: "http://www.yelpreviewgenerator.com/review/\(stars)/\(business).json")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var error: NSError?;
                let options = NSJSONReadingOptions(0)
                let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: options, error: &error)
                
                // Call closure
                if let decodedObject = jsonObject as? NSDictionary {
                    let review = decodedObject["review"]! as String
                    completion(rating: review)
                }
            })
        })
        task.resume()
    }
    
    @IBAction func regenerate(sender: AnyObject) {
        generate(self.stars, business: self.business)
    }
    
    @IBAction func copyToClipboardButton(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = self.resultText.text
        let alert = UIAlertView()
        alert.title = "Done"
        alert.message = "Your review is in clipboard. You can paste it now."
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.generateButton.layer.borderColor = self.UIColorFromRGB(0x81451D).CGColor
        self.generateButton.layer.borderWidth = 2
        self.generateButton.layer.cornerRadius = 4.0
        self.generateButton.tintColor = self.UIColorFromRGB(0x81451D)
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit

        self.floatRatingView.rating = 3
        self.initialized = true
        //self.generateButton.backgroundColor = UIColor.blueColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generate(stars: Int, business: String) -> Void {
        if initialized {
            //self.resultContainer.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                self.resultContainer.alpha = 0
            })
        }
        getRating(stars, business: "Bar") { (review) -> Void in
            self.stars = stars
            self.business = business
            self.businessType.text = business.capitalizedString
            self.floatRatingView.rating = Float(stars)
            self.resultText.text = review
            self.resultText.setContentOffset(CGPointMake(0, 0), animated: true)
//            if self.resultContainer.hidden {self.resultContainer.hidden = false}
            UIView.animateWithDuration(0.5, animations: {
                self.resultContainer.alpha = 1.0
            })
            
        }
    
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        // self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating)
    }


}
