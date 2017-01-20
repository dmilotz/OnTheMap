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
 
    @IBOutlet var mapView: MKMapView!
    var students: [OTMStudent] = [OTMStudent]()
    var flagDone: Bool = false
    
    @IBAction func createStudent(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "EnterStudentInfoViewController")
        self.present(controller, animated: true, completion: nil)
    }
   
    
    @IBAction func refreshMap(_ sender: Any) {
       getStudents()
    }
    override func viewDidLoad() {
       //getStudents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       getStudents()
    }
    
    
    func checkForExistingStudent(){
        
    }
    
    func getStudents(){
        
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


    }
    
    
    // MARK: - MKMapViewDelegate
    
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

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }

}
