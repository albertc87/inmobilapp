//
//  ViewController.swift
//  inmobilapp
//
//  Created by Alberto Castro on 13/11/14.
//  Copyright (c) 2014 Alberto Castro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, FilterSearchDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var loadIndicator: UIActivityIndicatorView!
    @IBOutlet var map: MKMapView!
    @IBOutlet var labelRadio: UILabel!
    var locationManager : CLLocationManager!
    var theSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.006, 0.006)
    var coord: CLLocationCoordinate2D!
    var initFirst = true
    var circle : MKCircle!
    var radius : Double = 300.0
    var changeRadius : Bool = true
    var locations : NSSet!
    var currentAnnotation : MKAnnotation!
    
    let kJSONURL: NSURL = NSURL(string: "http://mimetics.co/inmuebles.json")!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        Inmueble.createDatabaseInDocuments()
        self.getJson()
        locations = self.getInmuebles()
        
        map.delegate = self
        map.showsUserLocation = true
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        coord = locationObj.coordinate
        
        //Muestra la ubicacion en donde se encuentra el punto
        if(self.initFirst){
            var region: MKCoordinateRegion = MKCoordinateRegionMake(coord, theSpan)
            self.map.setRegion(region, animated:true)
            self.initFirst = false
        }
        //eliminar capa
        if(circle != nil){
            self.map.removeOverlay(circle)
        }
        //agregar capa
        circle = MKCircle(centerCoordinate: coord, radius: radius as CLLocationDistance)
        self.map.addOverlay(circle)
        
        //Filtrar objetos del mapa
        if(self.changeRadius){
            self.map.removeAnnotations(self.map.annotations)
            //self.map.addAnnotations(self.locations.allObjects)
            
            var nearlyLocations : NSSet = self.filterLocations(self.locations, coord: self.coord)
            if(nearlyLocations.count > 0){
                self.map.addAnnotations(nearlyLocations.allObjects)
            }
            
            self.changeRadius = false
        }
        
    }
    
    func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayView! {
        if (overlay is MKCircle) {
            var circle = MKCircleRenderer(overlay: overlay)
            //circle.strokeColor = UIColor.redColor()
            //circle.lineWidth = 0.5
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            
            //return circle
            return nil
        } else {
            return nil
        }
    }

    /*func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if (overlay is MKCircle) {
            var circle = MKCircleRenderer(overlay: overlay)
            //circle.strokeColor = UIColor.redColor()
            //circle.lineWidth = 0.5
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            
            return circle
        } else {
            return nil
        }
    }*/
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if(annotation.isKindOfClass(Inmueble)){
            var inmueble = annotation as! Inmueble;
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("Inmueble")
            if(annotationView == nil){
                annotationView = self.annotationView(inmueble)
            }else{
                annotationView.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        self.currentAnnotation = view.annotation
    }
    
    func initLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getJson(){
        if(Inmueble.searchAll().count == 0){
            loadIndicator.startAnimating()
            var data: NSData = NSData(contentsOfURL: self.kJSONURL)!
            self.loadJson(data)
        }

    }
    
    func loadJson(data: NSData){
        self.loadIndicator.stopAnimating()
        self.loadIndicator.hidden = true
        var error : NSError?
        
        var arrInmuebles: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
        var inmueble : Inmueble!
        for jsonInmueble in arrInmuebles {
            
            inmueble = Inmueble(coordinate: CLLocationCoordinate2D(latitude: (jsonInmueble.objectForKey("latitude")! as! NSString).doubleValue, longitude: (jsonInmueble.objectForKey("longitude")! as! NSString).doubleValue), title: "")
            inmueble.id = (jsonInmueble.objectForKey("id")! as! Int)
            inmueble.address = jsonInmueble.objectForKey("address")! as! String
            if(jsonInmueble.objectForKey("reference") != nil){
                inmueble.reference = jsonInmueble.objectForKey("reference")! as! String
            }
            inmueble.numberBathrooms = (jsonInmueble.objectForKey("numberBathrooms")! as! Int)
            inmueble.numberBedrooms = (jsonInmueble.objectForKey("numberBedrooms")! as! Int)
            inmueble.price = (jsonInmueble.objectForKey("price")! as! Int)
            inmueble.administrationCost = (jsonInmueble.objectForKey("administrationCost")! as! Int)
            inmueble.neighborhood = jsonInmueble.objectForKey("neighborhood")! as! String
            inmueble.type = jsonInmueble.objectForKey("type")! as! String
            inmueble.level = jsonInmueble.objectForKey("level")! as! String
            inmueble.area = (jsonInmueble.objectForKey("area")! as! Int)
            inmueble.title = "\(inmueble.neighborhood), \(inmueble.address)"
            if(jsonInmueble.objectForKey("typeKitchen") != nil){
                inmueble.typeKitchen = jsonInmueble.objectForKey("typeKitchen")! as! String
            }
            if jsonInmueble.objectForKey("haveParking")! as! NSString == "false"{
                inmueble.haveParking = false
            }else{
                inmueble.haveParking = true
            }
            
            if jsonInmueble.objectForKey("haveGasService")! as! NSString == "false"{
                inmueble.haveGasService = false
            }else{
                inmueble.haveGasService = true
            }
            
            if jsonInmueble.objectForKey("haveSurveillanceService")! as! NSString == "false"{
                inmueble.haveSurveillanceService = false
            }else{
                inmueble.haveSurveillanceService = true
            }
            inmueble.insertInDataBase()
        }
    }
    
    func filterLocations(locations:NSSet, coord:CLLocationCoordinate2D) -> NSSet{
        return locations.objectsPassingTest { (obj, boolPtr) in
            var point : Inmueble = obj as! Inmueble
            var testLocation: CLLocation = CLLocation(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude)
            var centerLocation: CLLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            let distance = centerLocation.distanceFromLocation(testLocation)
            var returnValue = distance <= self.radius
            return returnValue;
        }

    }
    
    func annotationView (inmueble: MKAnnotation) -> MKAnnotationView{
        var annotationView :MKAnnotationView = MKAnnotationView(annotation: inmueble, reuseIdentifier: "Inmueble")
        annotationView.enabled = true
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "home")
        var buttonAction : UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        buttonAction.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        annotationView.rightCalloutAccessoryView = buttonAction as UIView
        return annotationView
    }
    
    func buttonAction(sender:UIButton!){
        if(self.currentAnnotation != nil){
            var controller: DetailsViewController! = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsInmueble") as! DetailsViewController
            controller.title = "Detalles"
            controller.currentInmueble = self.currentAnnotation as! Inmueble
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func getInmueblesStatic() -> NSSet{
        
        //let point1 : Inmueble = Inmueble(coordinate: CLLocationCoordinate2D(latitude: 6.2456693, longitude: -75.5889699), title: "Punto1")
        var point1 : Inmueble = Inmueble(coordinate: CLLocationCoordinate2D(latitude: 6.2456693, longitude: -75.5889699), address: "Circular 5 # 71 - 10", numberBathrooms: 1, numberBedrooms: 1, price: 570000, neighborhood: "Laureles", type: "ApartaEstudio", level: "4", area: 30)
        point1.reference = "Cerca de la Notaria 13"
        //point1.insertInDataBase()
        let point2 : Inmueble = Inmueble(coordinate: CLLocationCoordinate2D(latitude: 6.2456693, longitude: -75.5899699), title: "Punto2")
        let point3 : Inmueble = Inmueble(coordinate: CLLocationCoordinate2D(latitude: 6.2556693, longitude: -75.5999699), title: "Punto3")
        return NSSet(array: Array(arrayLiteral: point1, point2, point3))
    }
    
    func getInmuebles() -> NSSet{
        //return NSSet(array: Inmueble.searchByFilter(filter))
        return NSSet(array: Inmueble.searchAll() as [AnyObject])
    }

    @IBAction func changeRadio(sender: AnyObject) {
        var size = (sender as! UISlider).value
        labelRadio.text = "[\(Int(size)) mts]"
        radius = Double(Int(size))
        changeRadius = true
    }

    @IBAction func updateLocation(sender: AnyObject) {
        if(coord != nil){
            var region: MKCoordinateRegion = MKCoordinateRegionMake(coord, theSpan)
            self.map.setRegion(region, animated:true)
            self.initFirst = true
            self.changeRadius = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "mySegue"{
            let vc = segue.destinationViewController as! SearchViewController
            //vc.colorString = colorLabel.text!
            vc.delegate = self
        }
    }
    
    
    //Delegate
    func returnSelectedInmueble(controller: SearchViewController,inmueble:FilterInmueble){
        self.locations = NSSet(array: Inmueble.searchByFilter(inmueble) as [AnyObject])
        self.changeRadius = true
        controller.navigationController?.popViewControllerAnimated(true)
        
    }
    
}

