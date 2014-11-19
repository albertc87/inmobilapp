//
//  Inmueble.swift
//  inmobilapp
//
//  Created by Alberto Castro on 14/11/14.
//  Copyright (c) 2014 Alberto Castro. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Inmueble : NSObject, MKAnnotation{
    var id: Int!
    //var description: String
    var coordinate: CLLocationCoordinate2D
    var title: String!
    var address: String!//
    var reference: String = ""//
    var numberBathrooms : Int = 0//
    var numberBedrooms : Int = 0//
    var price: Int!//
    var administrationCost: Int = 0//
    var neighborhood: String!//
    var haveParking: Bool = false//
    var haveGasService: Bool = false//
    var haveSurveillanceService : Bool = false //porteria
    var type: String!//
    var level: String!// Estrato
    var area: Int!//
    var typeKitchen : String = "NA"//Tipo cocina
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
    
    init(coordinate: CLLocationCoordinate2D, address: String, numberBathrooms: Int, numberBedrooms: Int, price: Int, neighborhood: String, type: String, level: String, area:Int){
        self.coordinate = coordinate
        self.title = "\(neighborhood), \(address)"
        self.address = address
        self.numberBathrooms = numberBathrooms
        self.numberBedrooms = numberBedrooms
        self.price = price
        self.neighborhood = neighborhood
        self.type = type
        self.level = level
        self.area = area
    }
}