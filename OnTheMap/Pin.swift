//
// Pin.swift
//  OnTheMap
//
//  Created by Dirk Milotz on 1/2/17.
//  Copyright © 2017 Dirk Milotz. All rights reserved.
//


import UIKit

// MARK: - Pin

struct Pin {
    
    // MARK: Properties
    
    let firstName: AnyObject
    let lastName: AnyObject
    let mapString: AnyObject
    let mediaUrl: AnyObject
    let longitude: AnyObject
    let latitude: AnyObject
    //let createdAt: Date
    let objectId: AnyObject
    
    // MARK: Initializers
    
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary["firstName"] as AnyObject
        lastName = dictionary["lastName"] as! AnyObject
        mapString = dictionary["mapString"] as! AnyObject
        mediaUrl = dictionary["mediaURL"] as! AnyObject
        longitude = dictionary["longitude"] as! AnyObject
        latitude = dictionary["latitude"] as! AnyObject
       // createdAt = dictionary["createdAt"] as! Date
        objectId = dictionary["objectId"] as! AnyObject
    }
    
    static func pinsFromResults(_ results: [[String:AnyObject]]) -> [Pin] {
        
        var pins = [Pin]()
        
        // iterate through array of dictionaries, each pin is a dictionary
        for result in results {
            pins.append(Pin(dictionary: result))
        }
        
        return pins
    }
    
}
