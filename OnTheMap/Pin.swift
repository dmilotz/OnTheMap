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
    
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaUrl: String?
    let longitude: Double?
    let latitude: Double?
    //let createdAt: Date
    let objectId: AnyObject
    
    // MARK: Initializers
    
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaUrl = dictionary["mediaURL"] as? String
        longitude = dictionary["longitude"] as? Double
        latitude = dictionary["latitude"] as? Double
       // createdAt = dictionary["createdAt"] as! Date
        objectId = dictionary["objectId"] as AnyObject
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
