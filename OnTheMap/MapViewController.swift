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
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "EnterLocationViewController") as! UIViewController
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
                print("Cannot find key '\(Constants.TMDBResponseKeys.Results)' in \(parsedResult)")
                return
            }
            
            /* 6. Use the data! */
            self.pins = Pin.pinsFromResults(results)
            
            print(self.pins)
            var annotations = [MKPointAnnotation]()
            for pin in self.pins{
                let lat = CLLocationDegrees(pin.latitude as! Double)
                let long = CLLocationDegrees(pin.longitude as! Double)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(pin.firstName) \(pin.lastName)"
                annotation.subtitle = pin.mediaUrl as? String
                annotations.append(annotation)
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
    //    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //
    //        if control == annotationView.rightCalloutAccessoryView {
    //            let app = UIApplication.sharedApplication()
    //            app.openURL(NSURL(string: annotationView.annotation.subtitle))
    //        }
    //    }
    
    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.
    
    func hardCodedLocationData() -> [[String : AnyObject]] {
        return  [
            [
                "createdAt" : "2015-02-24T22:27:14.456Z" as AnyObject,
                "firstName" : "Jessica" as AnyObject,
                "lastName" : "Uelmen" as AnyObject,
                "latitude" : 28.1461248 as AnyObject,
                "longitude" : -82.75676799999999 as AnyObject,
                "mapString" : "Tarpon Springs, FL" as AnyObject,
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en" as AnyObject,
                "objectId" : "kj18GEaWD8" as AnyObject,
                "uniqueKey" : 872458750 as AnyObject,
                "updatedAt" : "2015-03-09T22:07:09.593Z" as AnyObject
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z"as AnyObject,
                "firstName" : "Gabrielle"as AnyObject,
                "lastName" : "Miller-Messner"as AnyObject,
                "latitude" : 35.1740471as AnyObject,
                "longitude" : -79.3922539as AnyObject,
                "mapString" : "Southern Pines, NC"as AnyObject,
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en"as AnyObject,
                "objectId" : "8ZEuHF5uX8"as AnyObject,
                "uniqueKey" : 2256298598 as AnyObject,
                "updatedAt" : "2015-03-11T03:23:49.582Z" as AnyObject
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z"as AnyObject,
                "firstName" : "Jason"as AnyObject,
                "lastName" : "Schatz"as AnyObject,
                "latitude" : 37.7617as AnyObject,
                "longitude" : -122.4216as AnyObject,
                "mapString" : "18th and Valencia, San Francisco, CA"as AnyObject,
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29"as AnyObject,
                "objectId" : "hiz0vOTmrL"as AnyObject,
                "uniqueKey" : 2362758535 as AnyObject,
                "updatedAt" : "2015-03-10T17:20:31.828Z"as AnyObject
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z"as AnyObject,
                "firstName" : "Jarrod"as AnyObject,
                "lastName" : "Parkes"as AnyObject,
                "latitude" : 34.73037as AnyObject,
                "longitude" : -86.58611000000001as AnyObject,
                "mapString" : "Huntsville, Alabama"as AnyObject,
                "mediaURL" : "https://linkedin.com/in/jarrodparkes"as AnyObject,
                "objectId" : "CDHfAy8sdp"as AnyObject,
                "uniqueKey" : 996618664 as AnyObject,
                "updatedAt" : "2015-03-13T03:37:58.389Z" as AnyObject
            ]
        ]
    }
}

