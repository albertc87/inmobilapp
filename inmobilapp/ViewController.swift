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
    var theSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.003, 0.003)
    var coord: CLLocationCoordinate2D!
    var initFirst = true
    var circle : MKCircle!
    var radius : Double = 100.0
    var changeRadius : Bool = true
    var locations : NSSet!
    var currentAnnotation : MKAnnotation!
    
    let url: String = "http://mimetics.co/inmuebles.json"

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIndicator.startAnimating()
        initLocationManager()
        locations = self.getInmuebles()
        Inmueble.createDatabaseInDocuments()
        //Inmueble.searchAll()
        
        
        map.delegate = self
        map.showsUserLocation = true
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
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
        if(locations.count > 0 && self.changeRadius){
            self.map.removeAnnotations(self.map.annotations)
            
            var nearlyLocations : NSSet = self.filterLocations(self.locations, coord: self.coord)
            //self.exists(nearlyLocations.allObjects, annotationsInMap: self.map.annotations)
            if(nearlyLocations.count > 0){
                self.map.addAnnotations(nearlyLocations.allObjects)
            }
            
            self.changeRadius = false
        }
        
    }
    
    func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if (overlay is MKCircle) {
            var circle = MKCircleRenderer(overlay: overlay)
            //circle.strokeColor = UIColor.redColor()
            //circle.lineWidth = 0.5
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            
            return circle
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if(annotation.isKindOfClass(Inmueble)){
            var inmueble = annotation as Inmueble;
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
    
    func filterLocations(locations:NSSet, coord:CLLocationCoordinate2D) -> NSSet{
        return locations.objectsPassingTest { (obj, boolPtr) in
            var point : Inmueble = obj as Inmueble
            var testLocation: CLLocation = CLLocation(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude)
            var centerLocation: CLLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            var returnValue = centerLocation.distanceFromLocation(testLocation) <= self.radius
            return returnValue;
        }

    }
    
    func annotationView (inmueble: MKAnnotation) -> MKAnnotationView{
        var annotationView :MKAnnotationView = MKAnnotationView(annotation: inmueble, reuseIdentifier: "Inmueble")
        annotationView.enabled = true
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "home")
        var buttonAction : UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        buttonAction.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        annotationView.rightCalloutAccessoryView = buttonAction as UIView
        return annotationView
    }
    
    func buttonAction(sender:UIButton!){
        if(self.currentAnnotation != nil){
            var controller: DetailsViewController! = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsInmueble") as DetailsViewController
            controller.title = "Detalles"
            controller.currentInmueble = self.currentAnnotation as Inmueble
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func getInmuebles() -> NSSet{
        
        //let point1 : Inmueble = Inmueble(coordinate: CLLocationCoordinate2D(latitude: 6.2456693, longitude: -75.5889699), title: "Punto1")
        var point1 : Inmueble = Inmueble(coordinate: CLLocationCoordinate2D(latitude: 6.2456693, longitude: -75.5889699), address: "Circular 5 # 71 - 10", numberBathrooms: 1, numberBedrooms: 1, price: 570000, neighborhood: "Laureles", type: "ApartaEstudio", level: "4", area: 30)
        point1.reference = "Cerca de la Notaria 13"
        //point1.insertInDataBase()
        let point2 : Inmueble = Inmueble(coordinate: CLLocationCoordinate2D(latitude: 6.2456693, longitude: -75.5899699), title: "Punto2")
        let point3 : Inmueble = Inmueble(coordinate: CLLocationCoordinate2D(latitude: 6.2556693, longitude: -75.5999699), title: "Punto3")
        return NSSet(array: Array(arrayLiteral: point1, point2, point3))
    }

    @IBAction func changeRadio(sender: AnyObject) {
        var size = (sender as UISlider).value
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
            let vc = segue.destinationViewController as SearchViewController
            //vc.colorString = colorLabel.text!
            vc.delegate = self
        }
    }
    
    
    //Delegate
    func returnSelectedInmueble(controller: SearchViewController,inmueble:FilterInmueble){
        println(inmueble.type)
        controller.navigationController?.popViewControllerAnimated(true)
        
    }
    
}

