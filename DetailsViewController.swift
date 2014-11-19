//
//  DetailsViewController.swift
//  inmobilapp
//
//  Created by BYRON on 17/11/14.
//  Copyright (c) 2014 Alberto Castro. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    var currentInmueble : Inmueble!
    @IBOutlet var priceInmueble: UILabel!
    @IBOutlet var administrationCostInmueble: UILabel!
    @IBOutlet var typeInmueble: UILabel!
    @IBOutlet var neighborhoodInmueble: UILabel!
    @IBOutlet var addressInmueble: UILabel!
    @IBOutlet var referenceInmueble: UILabel!
    @IBOutlet var typeKitchenInmueble: UILabel!
    @IBOutlet var numberBedroomsInmueble: UILabel!
    @IBOutlet var numberBathroomsInmueble: UILabel!
    @IBOutlet var haveSurveillanceServiceInmueble: UILabel!
    @IBOutlet var haveParkingInmueble: UILabel!
    @IBOutlet var haveGasServiceInmueble: UILabel!
    @IBOutlet var levelInmueble: UILabel!
    @IBOutlet var areaInmueble: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        priceInmueble.text = "$\(currentInmueble.price)"
        administrationCostInmueble.text = "$\(currentInmueble.administrationCost)"
        typeInmueble.text = currentInmueble.type
        neighborhoodInmueble.text = currentInmueble.neighborhood
        addressInmueble.text = currentInmueble.address
        referenceInmueble.text = currentInmueble.reference
        typeKitchenInmueble.text = currentInmueble.typeKitchen
        numberBedroomsInmueble.text = String(currentInmueble.numberBedrooms)
        numberBathroomsInmueble.text = String(currentInmueble.numberBathrooms)
        if currentInmueble.haveSurveillanceService {
            haveSurveillanceServiceInmueble.text = "Si"
        }else{
            haveSurveillanceServiceInmueble.text = "No"
        }
        if currentInmueble.haveParking {
            haveParkingInmueble.text = "Si"
        }else{
            haveParkingInmueble.text = "No"
        }
        if currentInmueble.haveGasService {
            haveGasServiceInmueble.text = "Si"
        }else{
            haveGasServiceInmueble.text = "No"
        }
        levelInmueble.text = currentInmueble.level
        areaInmueble.text = "\(currentInmueble.area) M2"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
