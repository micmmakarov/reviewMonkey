//
//  ViewController.swift
//  YelpReview
//
//  Created by Michael on 12/28/14.
//  Copyright (c) 2014 Michael. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var businessPicker: UIPickerView!
    @IBOutlet weak var businessLabel: UILabel!

    let pickerData = ["Bar", "Hotel", "DMV"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        businessPicker.dataSource = self
        businessPicker.delegate = self
    }

    @IBAction func generate(sender: AnyObject) {
        let view = self.storyboard?.instantiateViewControllerWithIdentifier("result") as resultViewController
        view.generate(5, business: "bar")
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
        businessLabel.text = pickerData[row]
    }
    
}

