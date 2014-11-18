//
//  SearchViewController.swift
//  inmobilapp
//
//  Created by Alberto Castro on 18/11/14.
//  Copyright (c) 2014 Alberto Castro. All rights reserved.
//

import UIKit
class SearchViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var neighborhoodPicker: UIPickerView!
    
    @IBOutlet weak var neighborhoodSelect: UILabel!
    let neighborhoodData = ["Laureles", "Poblado", "San Joaquin", "Robledo","Calasanz"]
    override func viewDidLoad() {
        super.viewDidLoad()
        neighborhoodPicker.delegate = self
        neighborhoodPicker.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return neighborhoodData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return neighborhoodData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //neighborhoodSelect.text = neighborhoodData[row]
    }


}
