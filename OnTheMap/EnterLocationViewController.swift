//
//  PinEditorViewController.swift
//  OnTheMap
//
//  Created by Dirk Milotz on 1/2/17.
//  Copyright © 2017 Dirk Milotz. All rights reserved.
//

import Foundation
import UIKit

class EnterLocationViewController: UIViewController {
    
    
    @IBOutlet var studentLocation: UITextField!
    @IBAction func Submit(_ sender: UIButton) {
        if studentLocation.hasText{
            performSegue(withIdentifier: "sendLocationName", sender: studentLocation.text)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "sendLocationName") {
            print("Sending on over!")
            print(studentLocation.text!)
            let linkViewController = segue.destination as! EnterLinkViewController
            let locationText = sender as! String
            linkViewController.locationName = locationText
        }
    }
    
}
