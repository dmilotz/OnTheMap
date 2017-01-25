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
class EnterStudentInfoViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    var locationName: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    

   
    @IBOutlet var waitingIndicator: UIActivityIndicatorView!
    
    @IBOutlet var mapView: MKMapView!

    @IBOutlet var otmButton: UIButton!
    
    
    @IBOutlet var linkTextView: UITextView!
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func cancelButton(_ sender: Any) {
       goToMapView()
    }
    
    @IBAction func Submit(_ sender: UIButton) {
        switch sender.currentTitle! {
            case "Find On The Map":
                self.locationName = textField.text!
                waitingIndicator.isHidden=false
                waitingIndicator.startAnimating()
                self.placePinLocation()
                textField.resignFirstResponder()
            case "Submit":
                let validUrl = UIApplication.shared.canOpenURL( NSURL(string: linkTextView.text) as! URL)
                if(validUrl){
                self.postToParse()
                }else{
                    displayError("Please Enter A Valid URL", error: "")
                }
            default: break
            }
        }
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        linkTextView.delegate = self
        linkTextView.adjustsFontForContentSizeCategory = true

        linkTextView.sizeToFit()
        linkTextView.layoutIfNeeded()
        let height = linkTextView.sizeThatFits(CGSize(width: linkTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        linkTextView.contentSize = height
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        waitingIndicator.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstDisplayState()
        subscribeToKeyboardNotifications()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
    }

    
    func tap(gesture: UITapGestureRecognizer) {
        textField.resignFirstResponder()
        linkTextView.resignFirstResponder()
    }
    
    func resizeFontInTextView(){
    
    }
    
    
    func goToMapView(){
        OperationQueue.main.addOperation{
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)}
    }
    
 
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        linkTextView.text=""
    }
    
   
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
    
    func firstDisplayState(){
        mapView.isHidden = true
        
        otmButton.setTitle("Find On The Map", for: UIControlState.normal)
        otmButton.layer.cornerRadius = 5
        
        textField.isHidden = false
        textField.clearsOnBeginEditing = true
        textField.borderStyle = UITextBorderStyle.none
        textField.layer.borderWidth = 0.0
        
        linkTextView.layer.borderWidth = 0.0
        linkTextView.text = "Where are you studying today?"
       
    }
    
    func changeDisplayAfterLocationEntered(){
        self.mapView.isHidden = false
        self.otmButton.setTitle("Submit", for: UIControlState.normal)
        self.textField.isHidden = true
        self.linkTextView.isEditable = true
        self.linkTextView.text = "Enter a link to share here..."
        
    }
    
    func postToParse(){
       
        let postParams = "{\"uniqueKey\": \"" + OTMCurrentUser.userId + "\", \"firstName\": \"" + OTMCurrentUser.firstName + "\", \"lastName\": \"" + OTMCurrentUser.lastName + "\",\"mapString\": \""+locationName+"\", \"mediaURL\": \""+linkTextView.text!+"\",\"latitude\": \(Double(latitude)), \"longitude\": \(Double(longitude))}"
        
        OTMClient.sharedInstance().taskForParsePOSTMethod(url: OTMClient.Constants.parseUrl, jsonBody: postParams, completionHandlerForPOST: {(results,error) in
            if (error != nil){
                self.displayError("", error: String(describing: error))
                
            }
            else{
               self.goToMapView()
                
            }
        })
    
    }
    
    
    private func displayError(_ title: String, error: String) {
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: title, message:
                error, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShow(notification: Notification) {
        if textField.isEditing  == true{
            print (getKeyboardHeight(notification: notification))
            let height = getKeyboardHeight(notification: notification)
            view.frame.origin.y -= height/3
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func placePinLocation(){
        CLGeocoder().geocodeAddressString(self.locationName, completionHandler: {(placemarks,error) in
            if error != nil {
                self.displayError("Location not found, please try again.", error: "")
                self.waitingIndicator.stopAnimating()
                self.waitingIndicator.isHidden=true
                
                return
            }
            if (placemarks?.count)! > 0 {
                print (placemarks)
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
                self.waitingIndicator.stopAnimating()
                self.waitingIndicator.isHidden=true
                self.changeDisplayAfterLocationEntered()
                
            }else{
                self.displayError("Location was not found. Please try again.", error: "")
                self.waitingIndicator.stopAnimating()
                self.waitingIndicator.isHidden=true
                self.firstDisplayState()
                return
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
