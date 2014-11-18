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
    var reference: String!//
    var numberBathrooms : Int!//
    var numberBedrooms : Int!//
    var price: Int!//
    var administrationCost: Int!//
    var neighborhood: String!
    var haveParking: Bool!
    var haveGasService: Bool!
    var haveSurveillanceService : Bool! //porteria
    var type: String!
    var level: String!// Estrato
    var area: Int!
    var typeKitchen : String!//Tipo cocina
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}