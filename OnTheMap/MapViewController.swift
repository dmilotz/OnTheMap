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
    var students: [OTMStudent] = [OTMStudent]()
    var flagDone: Bool = false
    
    @IBAction func createStudent(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "EnterLocationViewController")
        self.present(controller, animated: true, completion: nil)
    }
   
    
    @IBAction func refreshMap(_ sender: Any) {
       // self.parseRequest()
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
        OTMClient.sharedInstance().getStudents { (students, error) in
            if let students = students{
            
                self.students = students
                
                var annotations = [MKPointAnnotation]()
                for Student in self.students{
                    if Student.latitude == nil || Student.longitude == nil || Student.firstName == nil || Student.lastName == nil {
                        break
                    }
                    else{
                        var lat = 0.0
                        var long = 0.0
                        if Student.latitude != nil{
                            lat = CLLocationDegrees(Student.latitude!)
                            
                        }
                        else{
                            break
                        }
                        if Student.longitude != nil{
                            long = CLLocationDegrees(Student.longitude!)
                            
                        }
                        else{
                            break
                        }
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(Student.firstName!) \(Student.lastName!)"
                        annotation.subtitle = Student.mediaUrl
                        annotations.append(annotation)
                    }
                }
                
                self.mapView.addAnnotations(annotations)
            }
        }
    //   let results = OnTheMapClient.parseRequest()
//        if(!flagDone){
//            sleep(100)
//        }
//        var annotations = [MKPointAnnotation]()
//        
//        for Student in Students{
//            let lat = CLLocationDegrees(Student.latitude as! Double)
//            let long = CLLocationDegrees(Student.longitude as! Double)
//            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = "\(Student.firstName) \(Student.lastName)"
//            annotation.subtitle = Student.mediaUrl as! String
//            annotations.append(annotation)
//            
//        }
        
        // When the array is complete, we add the annotations to the map.
        /* 6. Use the data! */
        //print(self.Students)
    
        //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)



    }
    
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "Student"
        
        var mapView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if mapView == nil {
            mapView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            mapView!.canShowCallout = true
            mapView!.tintColor = .red
            mapView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            mapView!.annotation = annotation
        }
        
        return mapView
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
