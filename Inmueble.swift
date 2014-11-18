//
//  Inmueble.swift
//  inmobilapp
//
//  Created by Alberto Castro on 14/11/14.
//  Copyright (c) 2014 Alberto Castro. All rights reserved.
//

import Foundation
class Inmueble{
    var id: Int = 0
    var description: String = ""
    var address: String = ""
    var reference: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var numberBathrooms : Int = 0
    var numberBedrooms : Int = 0
    var price: Int = 0
    var neighborhood: String = ""
    var administrationCost: Int = 0
    var haveParking: Bool = false
    var haveGasService: Bool = false
    var haveSurveillanceService : Bool = false //porteria
    var type: String = ""
    var level: String = ""// Estrato
    var area: Int = 0
    var typeKitchen : String = ""//Tipo cocina
    //TODO: imagenes y video
    //cargar los datos a partir del json, consultar los que estan en el radio
    func loadFromJSON(){
    
    }
    
    init(){
    
    }
    
}