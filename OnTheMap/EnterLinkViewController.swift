//
//  EnterLinkViewController.swift
//  OnTheMap
//
//  Created by Dirk Milotz on 1/2/17.
//  Copyright © 2017 Dirk Milotz. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class EnterLinkViewController: UIViewController, MKMapViewDelegate{
    
    var locationName: String = ""
    
    @IBOutlet var linkTextField: UITextView!
    

    @IBAction func Submit(_ sender: Any) {
    }
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        placePinLocation()
    }
    
    func placePinLocation(){
        CLGeocoder().geocodeAddressString(self.locationName, completionHandler: {(placemarks,error) in
            if error != nil {
                print(error)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate

            
            
                var annotations = [MKPointAnnotation]()
                let lat = CLLocationDegrees((coordinate?.latitude)!)
                let long = CLLocationDegrees((coordinate?.longitude)!)
                let locationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = locationCoordinate
                annotations.append(annotation)
                print(annotations)
                self.mapView.addAnnotations(annotations)
            }
            
            
            
            
        
        })
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    
}
