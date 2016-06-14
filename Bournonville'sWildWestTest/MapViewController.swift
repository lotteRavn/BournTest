//
//  MapViewController.swift
//  Bournonville'sWildWestTest
//
//  Created by Lotte Ravn on 06/06/16.
//  Copyright © 2016 Lotte Ravn. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate{
    
    var currentRoute: MKRoute?

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentPlacemark: CLPlacemark?
    var destination: MKMapItem = MKMapItem()
    
    
    
    
    var address: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.AuthorizedWhenInUse{
            mapView.showsUserLocation = true
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler:{ placemarks,error in
            if error != nil {
                print (error)
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                
                let annotation = MKPointAnnotation()
                annotation.title = "Bournonvilles wild west"
                annotation.subtitle = "Yi-Haaa"
                
                if let address = placemark.location{
                    annotation.coordinate = address.coordinate
                    
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                    
                }
            }
        })
    }
    @IBAction func findRouteButton(sender: AnyObject) {
        
     guard let currentPlacemark = currentPlacemark else{return}
        
     let directionRequest = MKDirectionsRequest()
     
     directionRequest.source = MKMapItem.mapItemForCurrentLocation()
     let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
     directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
     directionRequest.transportType = MKDirectionsTransportType.Automobile
     
     let directions = MKDirections(request: directionRequest)
     
     directions.calculateDirectionsWithCompletionHandler{ (routeResponse, routeError) -> Void in
     guard let routeResponse = routeResponse else{
        
     if let routeError = routeError {
     print("Error: \(routeError)")
     }
     return
     }
     let route = routeResponse.routes[0]
    self.currentRoute = route
    self.mapView.removeOverlays(self.mapView.overlays)
       
     self.mapView.addOverlay(route.polyline,level: MKOverlayLevel.AboveRoads)
        
        let rect = route.polyline.boundingMapRect
        self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)

        
     }
     
     }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) ->MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        return renderer
    
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "BournonvillesPin"
        if annotation.isKindOfClass(MKUserLocation){
        return nil
        }
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        if  annotationView == nil {
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        let leftIconView = UIImageView(frame: CGRectMake(0,0,50,50))
        leftIconView.image = UIImage(named:"logoBournonville")
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        annotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        
        return annotationView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccesoryControlTapped control: UIControl){
        performSegueWithIdentifier("showSteps", sender: view)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSteps" {
        let routeTableViewController = segue.destinationViewController as! RouteTableViewController
            if let steps = currentRoute?.steps {
            routeTableViewController.routeSteps = steps
            }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that ca
        // Do any additional setup after loading the view.
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
