//
//  ViewController.swift
//  YelpReview
//
//  Created by Michael on 12/28/14.
//  Copyright (c) 2014 Michael. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate, FloatRatingViewDelegate {

    @IBOutlet weak var businessPicker: UIPickerView!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet weak var generateButton: UIButton!
    
    let pickerData = ["Bar", "Hotel", "DMV", "Massage-HE", "Hospital", "Funeral-Home", "Restaurant"]
    
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
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 3
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = false
        
        self.generateButton.layer.borderColor = self.UIColorFromRGB(0x81451D).CGColor
        self.generateButton.layer.borderWidth = 2
        self.generateButton.layer.cornerRadius = 10.0
        //self.generateButton.backgroundColor = UIColor.blueColor()
        self.generateButton.tintColor = self.UIColorFromRGB(0x81451D)

        // Segmented control init
        // self.ratingSegmentedControl.selectedSegmentIndex = 1
        
        // Labels init
        // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating)
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating)
        
        businessPicker.dataSource = self
        businessPicker.delegate = self
        businessPicker.selectRow(4, inComponent: 0, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
    }

    @IBAction func generate(sender: AnyObject) {
        let view = self.storyboard?.instantiateViewControllerWithIdentifier("result") as resultViewController
        view.generate(Int(self.floatRatingView.rating), business: "bar")
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // businessLabel.text = pickerData[row]
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        // self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating)
    }
}

