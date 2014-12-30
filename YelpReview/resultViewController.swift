//
//  resultViewController.swift
//  YelpReview
//
//  Created by Michael on 12/28/14.
//  Copyright (c) 2014 Michael. All rights reserved.
//

import UIKit

class resultViewController: UIViewController {
    
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
    
    @IBOutlet weak var businessType: UILabel!
    @IBOutlet weak var stars: UILabel!
    @IBOutlet weak var resultText: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generate(stars: Int, business: String) -> Void {
        getRating(stars, business: "Bar") { (review) -> Void in
            self.businessType.text = business
            self.stars.text = "\(stars) stars"
            self.resultText.text = review
        }
    
    }

}
