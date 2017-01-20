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
class EnterStudentInfoViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate{
    
    var locationName: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    
//    @IBOutlet var textField: UITextField!
    
    @IBOutlet var studyingLabel: UILabel!
   
    @IBOutlet var mapView: MKMapView!

    @IBOutlet var otmButton: UIButton!
    
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func cancelButton(_ sender: Any) {
       goToMapView()
    }
    
    @IBAction func Submit(_ sender: UIButton) {
        switch sender.currentTitle! {
            case "Find On The Map":
                self.locationName = textField.text!
                self.placePinLocation()
                textField.resignFirstResponder()
            case "Submit":
                self.postToParse()
            default: break
            }
        }
 
    override func viewDidLoad() {
        textField.delegate = self
    }
    
   func viewWillAppear(){
        mapView.isHidden = true
        textField.isHidden = true
        otmButton.setTitle("Find On The Map", for: UIControlState.normal)
        textField.clearsOnBeginEditing = true
    
    }
    
    func goToMapView(){
        OperationQueue.main.addOperation{
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)}
    }
    
   func textFieldDidBeginEditing(_ textField: UITextField) {   textField.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func changeDisplayAfterLocationEntered(){
        self.mapView.isHidden = false
        self.otmButton.setTitle("Submit", for: UIControlState.normal)
        self.textField.isHidden = false
        self.studyingLabel.isHidden = true
        self.textField.text = "Please enter a link to share."
        
    }
    
    func postToParse(){
        let postParams = "{\"uniqueKey\": \"" + OTMCurrentUser.userId + "\", \"firstName\": \"" + OTMCurrentUser.firstName + "\", \"lastName\": \"" + OTMCurrentUser.lastName + "\",\"mapString\": \""+locationName+"\", \"mediaURL\": \""+textField.text!+"\",\"latitude\": \(Double(latitude)), \"longitude\": \(Double(longitude))}"
        
        OTMClient.sharedInstance().taskForParsePOSTMethod(url: OTMClient.Constants.parseUrl, jsonBody: postParams, completionHandlerForPOST: {(results,error) in
            if (error != nil){
                self.displayError(String(describing: error))
                
            }
            else{
               self.goToMapView()
                
            }
        })
    }
    
    
    private func displayError(_ error: String) {
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: "Location Post Error", message:
                error, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    func placePinLocation(){
        CLGeocoder().geocodeAddressString(self.locationName, completionHandler: {(placemarks,error) in
            if error != nil {
                self.displayError("Location not found, please try again.")
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
                self.mapView.addAnnotations(annotations)
                self.changeDisplayAfterLocationEntered()
                
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
