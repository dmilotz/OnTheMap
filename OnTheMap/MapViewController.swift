//
//  ViewController.swift
//  OnTheMap
//
//  Created by Dirk Milotz on 11/14/16.
//  Copyright © 2016 Dirk Milotz. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    var pins: [Pin] = [Pin]()
    var flagDone: Bool = false
    
    @IBAction func createPin(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "EnterLocationViewController") 
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func refreshMap(_ sender: Any) {
        self.parseRequest()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
            
     
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
        //let locations = hardCodedLocationData()
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
     //   var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
//        for dictionary in locations {
//
//            // Notice that the float values are being used to create CLLocationDegree values.
//            // This is a version of the Double type.
//            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
//            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
//            
//            // The lat and long are used to create a CLLocationCoordinates2D instance.
//            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            
//            let first = dictionary["firstName"] as! String
//            let last = dictionary["lastName"] as! String
//            let mediaURL = dictionary["mediaURL"] as! String
//            
//            // Here we create the annotation and set its coordiate, title, and subtitle properties
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = "\(first) \(last)"
//            annotation.subtitle = mediaURL
//            
//            // Finally we place the annotation in an array of annotations.
//            annotations.append(annotation)
//        }
        
       
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.parseRequest()
//        if(!flagDone){
//            sleep(100)
//        }
//        var annotations = [MKPointAnnotation]()
//        
//        for pin in pins{
//            let lat = CLLocationDegrees(pin.latitude as! Double)
//            let long = CLLocationDegrees(pin.longitude as! Double)
//            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = "\(pin.firstName) \(pin.lastName)"
//            annotation.subtitle = pin.mediaUrl as! String
//            annotations.append(annotation)
//            
//        }
        
        // When the array is complete, we add the annotations to the map.
        


    }
    
    func parseRequest(){
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Is the "results" key in parsedResult? */
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                print("Cannot find key '\("results")' in \(parsedResult)")
                return
            }
            
            
            /* 6. Use the data! */
            self.pins = Pin.pinsFromResults(results)
            
            //print(self.pins)
            var annotations = [MKPointAnnotation]()
            for pin in self.pins{
                if pin.latitude == nil || pin.longitude == nil || pin.firstName == nil || pin.lastName == nil {
                    break
                }
                else{
                var lat = 0.0
                var long = 0.0
                if pin.latitude != nil{
                   lat = CLLocationDegrees(pin.latitude!)
                    
                }
                else{
                    break
                }
                if pin.longitude != nil{
                    long = CLLocationDegrees(pin.longitude!)

                }
                else{
                    break
                }
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(pin.firstName!) \(pin.lastName!)"
                annotation.subtitle = pin.mediaUrl
                annotations.append(annotation)
                }
            }
            
            self.mapView.addAnnotations(annotations)
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
        
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    //    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, }

}
