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
    @IBOutlet weak var starsCount: UISlider!
    @IBOutlet var floatRatingView: FloatRatingView!
    
    let pickerData = ["Bar", "Hotel", "DMV"]
    
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
        
        // Segmented control init
        // self.ratingSegmentedControl.selectedSegmentIndex = 1
        
        // Labels init
        // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating)
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating)
        
        businessPicker.dataSource = self
        businessPicker.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
    }

    @IBAction func generate(sender: AnyObject) {
        let view = self.storyboard?.instantiateViewControllerWithIdentifier("result") as resultViewController
        view.generate(Int(self.starsCount.value), business: "bar")
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

