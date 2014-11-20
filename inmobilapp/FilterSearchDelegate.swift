//
//  FilterSearchDelegate.swift
//  inmobilapp
//
//  Created by Alberto Castro on 19/11/14.
//  Copyright (c) 2014 Alberto Castro. All rights reserved.
//

import Foundation

protocol FilterSearchDelegate{
    func returnSelectedInmueble(controller: SearchViewController, inmueble:FilterInmueble)
}