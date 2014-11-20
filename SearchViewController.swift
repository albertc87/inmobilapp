//
//  SearchViewController.swift
//  inmobilapp
//
//  Created by Alberto Castro on 18/11/14.
//  Copyright (c) 2014 Alberto Castro. All rights reserved.
//

import UIKit
class SearchViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    @IBOutlet var typeInmueble: UISegmentedControl!
    @IBOutlet weak var neighborhoodPicker: UIPickerView!
    @IBOutlet var numberBathroomsInmueble: UITextField!
    @IBOutlet var numberBedroomsInmueble: UITextField!
    @IBOutlet var priceOfInmueble: UITextField!
    @IBOutlet var priceUntilInmueble: UITextField!
    @IBOutlet var haveParkingInmueble: UISwitch!
    @IBOutlet var haveSurveillanceServiceInmueble: UISwitch!
    @IBOutlet var haveGasServiceInmueble: UISwitch!
    @IBOutlet var levelInmueble: UITextField!
    var selectedNeighborhood : String!
    var delegate: FilterSearchDelegate! = nil
    
    let neighborhoodData = ["Todos", "Laureles", "Poblado", "San Joaquin", "Robledo","Calasanz"]
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
        selectedNeighborhood = neighborhoodData[row]
        return neighborhoodData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedNeighborhood = neighborhoodData[row]
    }
    
    @IBAction func search(sender: AnyObject) {
        var filter = FilterInmueble()
        if(typeInmueble.selectedSegmentIndex == 0){
            filter.type = "Apartamento"
        }else{
            filter.type = "Casa"
        }
        filter.neighborhood = selectedNeighborhood
        filter.numberBedrooms = numberBedroomsInmueble.text.toInt()
        filter.numberBathrooms = numberBathroomsInmueble.text.toInt()
        filter.priceOf = priceOfInmueble.text.toInt()
        filter.priceUntil = priceUntilInmueble.text.toInt()
        filter.haveParking = haveParkingInmueble.on
        filter.haveSurveillanceService = haveSurveillanceServiceInmueble.on
        filter.haveGasService = haveGasServiceInmueble.on
        filter.level = levelInmueble.text
        
        delegate!.returnSelectedInmueble(self,inmueble: filter)
        
    }
    


}
