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
class EnterStudentInfoViewController: UIViewController{
  
    /// MARK: Properties
    var locationName: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    

  
    /// MARK: Outlets
    @IBOutlet var waitingIndicator: UIActivityIndicatorView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var otmButton: UIButton!
    @IBOutlet var linkTextView: UITextView!
    @IBOutlet var textField: UITextField!

}

// MARK: - Lifecycle methods
  extension EnterStudentInfoViewController{
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
}


// MARK: - Actions
extension EnterStudentInfoViewController{
  @IBAction func cancelButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func Submit(_ sender: UIButton) {
    switch sender.currentTitle! {
    case "Find On The Map":
      self.locationName = textField.text!
      DispatchQueue.main.async{
        self.waitingIndicator.startAnimating()
      }
      self.placePinLocation()
      textField.resignFirstResponder()
    case "Submit":
      let validUrl = UIApplication.shared.canOpenURL( NSURL(string: linkTextView.text) as! URL)
      if(validUrl){
        self.postToParse()
      }else{
        displayAlert("Please Enter A Valid URL", title: "")
      }
    default: break
    }
  }
}

private extension EnterStudentInfoViewController{

    @objc func tap(gesture: UITapGestureRecognizer) {
        textField.resignFirstResponder()
        linkTextView.resignFirstResponder()
    }

    func resizeFontInTextView(){
    
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
        self.displayAlert("Error", title: String(describing: error!.localizedDescription))
        
      }
      else{
        self.dismiss(animated: true, completion: nil)
      }
    })
    

}
  
  
  func placePinLocation(){
    CLGeocoder().geocodeAddressString(self.locationName, completionHandler: {(placemarks,error) in
      if error != nil {
        self.displayAlert("Location not found, please try again.", title: "Error")
        DispatchQueue.main.async{
          self.waitingIndicator.stopAnimating()
        }
        
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
        DispatchQueue.main.async{
          self.waitingIndicator.stopAnimating()
        }
        self.changeDisplayAfterLocationEntered()
        let span = MKCoordinateSpanMake(5, 5)
        let region = MKCoordinateRegion(center: coordinate!, span: span)
        self.mapView.setRegion(region, animated: true)
        
      }else{
        self.displayAlert("Location was not found. Please try again.", title: "Error")
        DispatchQueue.main.async{
          self.waitingIndicator.stopAnimating()
        }
        self.firstDisplayState()
        return
      }
      
      
      
      
      
      
    })
  }

}

// MARK: - UITextViewDelegate, UITextFieldDelegate
extension EnterStudentInfoViewController: UITextViewDelegate, UITextFieldDelegate{
  
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
}


// MARK: - Keyboard notification methods
  extension EnterStudentInfoViewController{
    
    
    
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
    
}


// MARK: - MKMapViewDelegate
extension EnterStudentInfoViewController: MKMapViewDelegate{
    
    
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
