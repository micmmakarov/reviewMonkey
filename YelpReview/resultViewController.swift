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
    var regenerations = 0;
    var business: String = "";
    var initialized = false;
    var case1 = false
    let loadingLabels = ["Currently :N: monkeys are working on writing your rewiew", "The server is connecting to the future through :W:", "Loading organic coffee to the server to generate a review", "Using organic bicycle energy to create this review", "Watching a Netflix series to get inspired for this one", "Feeding the server with kombucha", "Looking at :N: images of cute kittens for inspiration"]
    let lw = ["matrix", "tv", "monkeys", "magic mongks", "kittens"]
    
    func getLoadingLabel() -> String {
        var randomIndex = Int(arc4random_uniform(UInt32(self.loadingLabels.count)))
        var randomLabel = self.loadingLabels[randomIndex]
        randomIndex = Int(arc4random_uniform(UInt32(self.lw.count)))
        var randomWord = self.lw[randomIndex]
        let randomNumber = String(arc4random_uniform(UInt32(20)))
        var result =
        randomLabel.stringByReplacingOccurrencesOfString(":N:", withString: randomNumber, options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(":W:", withString: randomWord, options: NSStringCompareOptions.LiteralSearch, range: nil)
        return result
    }
    
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var businessType: UILabel!
    //@IBOutlet weak var stars: UILabel!
    @IBOutlet weak var resultText: UITextView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var resultContainer: UIView!
    var back: UIImageView!
    var front: UIImageView!
    var result: UITextView!
    var loading = false
    var shareText = ""
    var shareUrl = ""
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var loadingTextView: UITextView!
    
    func startLoading() {
        self.loading = true
        self.generateButton.hidden = true
        self.shareView.hidden = true
        self.loadingView.hidden = false
        self.loadingTextView.text = getLoadingLabel()
        self.loadingTextView.font = UIFont(name: "Helvetica", size: 16)

    }
    
    func stopLoading() {
        if self.regenerations == 2 {
            self.generateButton.setTitle("New review", forState: UIControlState.Normal)
            self.generateButton.backgroundColor = self.UIColorFromRGB(0x81451D)
            self.generateButton.tintColor = self.UIColorFromRGB(0xFFFFFF)

        }
        self.loadingView.hidden = true
        self.loading = false
        self.generateButton.hidden = false
        self.shareView.hidden = false
        UIView.animateWithDuration(0.5, animations: {
            self.resultText.alpha = 1
        })
    }

    // Main API call
    func getRating(stars: Int, business: String, completion: (rating: String) -> Void) {
        var url = NSURL(string: "http://www.reviewmonkeyapp.com/review/\(stars)/\(business).json")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var error: NSError?;
                let options = NSJSONReadingOptions(0)
                let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: options, error: &error)
                
                // Call closure
                if let decodedObject = jsonObject as? NSDictionary {
                    let review = decodedObject["review"]! as String
                    self.shareText = decodedObject["shareText"]! as String
                    self.shareUrl = decodedObject["shareUrl"]! as String
                    completion(rating: review)
                }
            })
        })
        task.resume()
    }
    
    @IBAction func regenerate(sender: AnyObject) {
        generate(self.stars, business: self.business)
    }
    
    @IBOutlet weak var shareView: UIView!
    
    @IBAction func shareAction(sender: AnyObject) {
        let textToShare = "I just wrote a \(self.stars)-star review for a \(self.business): " + self.resultText.text
        
        if let myWebsite = NSURL(string: "http://www.reviewmonkeyapp.com/")
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            // activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }    }
    
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
        self.loadingView.hidden = true

        self.initialized = true
        //self.generateButton.backgroundColor = UIColor.blueColor()
        self.back = UIImageView(image: UIImage(named: "StarFull"))
        self.front = UIImageView(image: UIImage(named: "StarEmpty"))
        self.front.alpha = 0.01
        self.back.alpha = 0.01
        //let rect = CGRectMake(5, 5, resultContainer.frame.width - 10, resultContainer.frame.height - 10)
        //self.result = UITextView(frame: rect)

        self.resultContainer.addSubview(self.front)
        self.resultContainer.addSubview(self.back)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func generate(stars: Int, business: String) -> Void {
        //self.resultContainer.hidden = true
        //UIView.animateWithDuration(0.5, animations: {
        //    self.resultContainer.alpha = 0
        //})
        self.regenerations++
        if self.regenerations < 3 {
        
        if self.initialized {
            //self.resultText.hidden = true
            self.resultText.alpha = 0
            self.startLoading()
            if self.case1 == false {
                UIView.transitionFromView(self.back, toView: self.front, duration: 5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: {
                    (fininshed: Bool) -> () in
                    self.stopLoading()
                })
                self.case1 = true
            } else {
                UIView.transitionFromView(self.front, toView: self.back, duration: 5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: {
                    (fininshed: Bool) -> () in
                    self.stopLoading()
                })
                self.case1 = false
            }
        }
            getRating(stars, business: business) { (review) -> Void in
                self.stars = stars
                self.business = business
                self.businessType.text = business.capitalizedString
                self.floatRatingView.rating = Float(stars)
                //if self.resultText.hidden {self.resultText.hidden = false}
                self.resultText.text = review
                self.resultText.setContentOffset(CGPointMake(0, 0), animated: false)
                self.resultText.font = UIFont(name: "Helvetica", size: 18)

            }
        } else {
           self.navigationController?.popViewControllerAnimated(true)
           // self.dismissViewControllerAnimated(true, completion: nil)
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
