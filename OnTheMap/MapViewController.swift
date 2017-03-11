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
    var flagDone: Bool = false
    
    @IBAction func createStudent(_ sender: Any) {
        if (userPinExists()){
            displayOverwriteAlert()
        }
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "EnterStudentInfoViewController")
        self.present(controller, animated: true, completion: nil)
    }
   
   
    
    @IBAction func refreshMap(_ sender: Any) {
        getStudents()
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        OTMClient.sharedInstance().logoutFromUdacity(completionHandlerLogout: { (results, error) in
            if (error != nil){
                self.displayAlert(String(describing: error), title: "Problem logging out")
                return
            }
            OperationQueue.main.addOperation {

            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func userPinExists()-> Bool{
        for student in StudentDataSource.sharedInstance.studentData{
            if student.firstName == OTMCurrentUser.firstName && student.lastName == OTMCurrentUser.lastName{
                return true
            }
            else{
                return false
            }
        }
        
        return false
        
    }


    override func viewWillAppear(_ animated: Bool) {
       getStudents()
    }
    
    
    func checkForExistingStudent(){
        
    }
    
    func getStudents(){
        
        OTMClient.sharedInstance().getStudents { (error) in
            if (error != nil){
                self.displayAlert("Failed to download student data.", title: "Error")
                return
            }
            else{
                
                var annotations = [MKPointAnnotation]()
                for Student in StudentDataSource.sharedInstance.studentData{
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
                self.mapView.removeAnnotations(self.mapView.annotations)
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
            if let toOpen = view.annotation?.subtitle! {
                if let url = URL(string: toOpen){
                    UIApplication.shared.openURL(url)
                }
                else{
                    let alertController = UIAlertController(title: "Url Error", message:
                        "Url did not work.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

}
