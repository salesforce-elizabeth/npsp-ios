//
//  MapViewController.swift
//  MyNPSPiOSApp
//
//  Created by Elizabeth Martin on 8/10/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    var mapView: MKMapView!
    var locationManager = CLLocationManager.init()
    
    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        
        //Set it as the view of this view controller
        view = mapView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Map view controller loaded its view.")
        print(loadedJobs.count)
        
        for i in 0..<loadedJobs.count {
            
            let latitudeDouble = loadedJobs[i].jobLatitude 
            let longitudeDouble = loadedJobs[i].jobLongitude 
            
            let latitude: CLLocationDegrees = latitudeDouble
            let longitude: CLLocationDegrees = longitudeDouble
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            annotation.title = loadedJobs[i].name
            annotation.subtitle = loadedJobs[i].description
            self.mapView.addAnnotation(annotation)
            
        }
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.delegate = self
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setCenter(userLocation.coordinate, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
