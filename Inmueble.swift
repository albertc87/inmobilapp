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
    
    class func searchPathOfDatabase() -> NSString{
        var rutaDocuments:AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        var databasePath = rutaDocuments.stringByAppendingString("/inmobilapp.db")
        println("La ruta \(databasePath)")
        return databasePath
    }
    
    class func createDatabaseInDocuments(){
        let databasePath = Inmueble.searchPathOfDatabase()
        var fileManager = NSFileManager.defaultManager()
        var db: COpaquePointer = nil
        var error: UnsafeMutablePointer<Int8> = nil
        if !fileManager.fileExistsAtPath(databasePath) {
            let dbpath = databasePath.UTF8String
            if sqlite3_open(dbpath, &db) == SQLITE_OK{
                println("La base de datos se creo exitosamente")
                var sql = "CREATE TABLE IF NOT EXISTS Inmueble (ID INTEGER PRIMARY KEY AUTOINCREMENT,description TEXT, address TEXT, reference TEXT, number_bathrooms TEXT, number_bedrooms TEXT, price TEXT, latitude TEXT, longitude TEXT, administrationCost TEXT, neighborhood TEXT, haveParking TEXT, haveGasService TEXT, haveSurveillanceService TEXT,type TEXT, level TEXT, area TEXT, typeKitchen TEXT)"

                
                
                if sqlite3_exec(db, sql, nil, nil, &error) == SQLITE_OK{
                    println("Tabla creada exitosamente")
                }else{
                    println("Error exitosamente")
                }
                sqlite3_close(db);
            }
            
        }else{
            println("El archivo existe")
        }
    }
    
    
    class func searchAll()->[Inmueble]{
        let databasePath = Inmueble.searchPathOfDatabase()
        var fileManager = NSFileManager.defaultManager()
        var db: COpaquePointer = nil
        var error: UnsafeMutablePointer<Int8> = nil
        var query: COpaquePointer = nil
        var inmuebles :[Inmueble] = []
        var inmueble : Inmueble!
        let dbpath = databasePath.UTF8String
            if sqlite3_open(dbpath, &db) == SQLITE_OK{
                var sql = "SELECT * FROM Inmueble"
                if sqlite3_prepare_v2(db,sql,-1,&query, nil) == SQLITE_OK{
                    while(sqlite3_step(query) == SQLITE_ROW){
                        var longitude: Double = sqlite3_column_double(query,7)
                        var latitude: Double = sqlite3_column_double(query,8)

                        var inmueble : Inmueble = Inmueble(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: "Default")
                        inmueble.id = Int(sqlite3_column_int(query,0))
                        inmueble.address = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(query,2)))
                        inmueble.reference = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(query,3)))!
                        inmueble.numberBathrooms =  Int(sqlite3_column_int(query,4))
                        inmueble.numberBedrooms = Int(sqlite3_column_int(query,5))
                        inmueble.price = Int(sqlite3_column_int(query,6))
                        inmueble.administrationCost =  Int(sqlite3_column_int(query,9))
                        inmueble.neighborhood =  String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(query,10)))
                        if String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(query,11)))? == "true" {
                                inmueble.haveParking = true
                        }else{
                                inmueble.haveParking = false
                        }
                        if String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(query,12)))? == "true" {
                            inmueble.haveGasService = true
                        }else{
                            inmueble.haveGasService = false
                        }
                        if String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(query,13)))? == "true" {
                            inmueble.haveSurveillanceService = true
                        }else{
                            inmueble.haveSurveillanceService = false
                        }
                        inmueble.type =  String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(query,14)))
                        inmueble.level =  String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(query,15)))
                        inmueble.area  =  Int(sqlite3_column_int(query,16))
                        inmueble.typeKitchen = String.fromCString(UnsafePointer<CChar>(sqlite3_column_text(query,17)))!
                        inmueble.title = "\(inmueble.neighborhood) , \(inmueble.address)"
                        NSLog("%@", inmueble)
                        inmuebles.append(inmueble)
                    }
                }
                sqlite3_finalize(query);
                sqlite3_close(db);
    
            }
        
        return inmuebles
    }
    
    
    /*
    -(void)insertEmployedInDatabase{
    [self searchPathOfDatabase];
    sqlite3_stmt * query;
    const char * db = [_databasePath UTF8String];
    if(sqlite3_open(db,&employed) == SQLITE_OK){
    NSString * insert = [NSString stringWithFormat:@"INSERT INTO Employed (EMP_NAME, EMP_CEDULA, EMP_JOB, EMP_PHONE, EMP_ADDRESS) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", _empName,_empCedula,_empJob,_empPhone,_empAddress];
    const char * insertsql = [insert UTF8String];
    sqlite3_prepare_v2(employed, insertsql, -1, &query, NULL);
    sqlite3_close(employed);
    if (sqlite3_step(query) == SQLITE_DONE) {
    _status = @"Empleado adicionado";
    }else{
    _status = @"Error al adicionar empleado";
    }
    sqlite3_finalize(query);
    sqlite3_close(employed);
    }else{
    NSLog(@"No se pudo acceder a la base de datos");
    }
    
    
    
    }
    
    -(void)searchEmployedInDatabase{
    [self searchPathOfDatabase];
    const char * db = [_databasePath UTF8String];
    sqlite3_stmt * query;
    
    if(sqlite3_open(db,&employed) == SQLITE_OK){
    //NSString * select = [NSString stringWithFormat:@" SELECT * FROM Employed WHERE EMP_CEDULA = \"%@\"", _empCedula];
    const char * selectsql = [[NSString stringWithFormat:@" SELECT * FROM Employed WHERE EMP_CEDULA = \"%@\"", _empCedula]UTF8String];
    if(sqlite3_prepare_v2(employed,selectsql,-1,&query, NULL) == SQLITE_OK){
    if(sqlite3_step(query) == SQLITE_ROW){
    _status = @"Empleado encontrado";
    _empId = [NSString stringWithFormat:@"%s", sqlite3_column_text(query,0) ];
    _empName = [NSString stringWithFormat:@"%s", sqlite3_column_text(query,1) ];
    _empJob = [NSString stringWithFormat:@"%s", sqlite3_column_text(query,3) ];
    _empPhone = [NSString stringWithFormat:@"%s", sqlite3_column_text(query,4) ];
    _empAddress = [NSString stringWithFormat:@"%s", sqlite3_column_text(query,5) ];
    
    }else{
    _status = @"Empleado no encontrado";
    _empName = _empPhone= _empAddress = _empJob = @"XXXXXXXXXXXXXX";
    }
    }else{
    _status = @"Error en el sql";
    }
    sqlite3_finalize(query);
    sqlite3_close(employed);
    
    }*/
    
    func insertInDataBase(){
        let databasePath = Inmueble.searchPathOfDatabase()
        var db: COpaquePointer = nil
        var query: COpaquePointer = nil
        let dbpath = databasePath.UTF8String
        if sqlite3_open(dbpath, &db) == SQLITE_OK{
            var sql = "INSERT INTO Inmueble (description, address, reference, number_bathrooms, number_bedrooms, price, latitude, longitude, administrationCost, neighborhood, haveParking, haveGasService, haveSurveillanceService, type, level, area, typeKitchen) VALUES (\"\",\"\(address)\",\"\(reference)\",\"\(numberBathrooms)\",\"\(numberBedrooms)\",\"\(price)\",\"\(coordinate.latitude)\",\"\(coordinate.longitude)\",\"\(administrationCost)\",\"\(neighborhood)\",\"\(haveParking)\",\"\(haveGasService)\",\"\(haveSurveillanceService)\",\"\(type)\",\"\(level)\",\"\(area)\",\"\(typeKitchen)\")"
            NSLog(sql)
            sqlite3_prepare_v2(db,sql,-1,&query, nil)
            if (sqlite3_step(query) == SQLITE_DONE) {
                NSLog("Datos agregados.")
            }else{
                NSLog("Error Adicionando el Inmueble")
            }
            sqlite3_finalize(query);
            sqlite3_close(db);
        }else{
            NSLog("No se Puede acceder a la base de datos.")
        }
    }

    func findByFilter(filter : FilterInmueble) ->NSArray{
        return []
    }

    
}