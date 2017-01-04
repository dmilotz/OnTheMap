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
    var longitude: Double = 0
    var latitude: Double = 0
    
    @IBOutlet var linkTextField: UITextView!
    


    @IBAction func Submit(_ sender: Any) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postParams = "{\"uniqueKey\": \"1234\", \"firstName\": \"Dirk\", \"lastName\": \"Milotz\",\"mapString\": \""+locationName+"\", \"mediaURL\": \""+linkTextField.text+"\",\"latitude\": \(Double(latitude)), \"longitude\": \(Double(longitude))}"
        print (postParams)
        
        request.httpBody = postParams.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)

            print (response)
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            OperationQueue.main.addOperation{
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.present(controller, animated: true, completion: nil)
            }
            
        }
        task.resume()
        
        
        
        
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
                self.latitude = lat
                self.longitude = long
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
