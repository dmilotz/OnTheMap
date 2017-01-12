//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Dirk Milotz on 1/11/17.
//  Copyright © 2017 Dirk Milotz. All rights reserved.
//

import Foundation
extension OTMClient{
    
    func getStudents(_ completionHandlerForGetStudents: @escaping (_ result: [OTMStudent]?, _ error: NSError?) -> Void) {
        
        
        /* Make the request */
        let _ = taskForGETMethod() { (parsedResults, error) in
            /* 3. Send to completion handler */
            print(parsedResults)
            if let error = error {
                completionHandlerForGetStudents(nil, error)
            } else {
                /* GUARD: Is the "results" key in parsedResult? */
                guard let results = parsedResults!["results"] as? [[String:AnyObject]] else {
                    print("Cannot find key 'results' in \(parsedResults)")
                    return
                }
                    let students = OTMStudent.studentsFromResults(results)
                    completionHandlerForGetStudents(students, nil)
               
            }
        }
    }
    
    
    func postStudents(_ student: OTMStudent, mediaUrl: String, locationName: String, completionHandlerForFavorite: @escaping (_ result: Int?, _ error: NSError?) -> Void) {
        
        let jsonBody = "{\"uniqueKey\": \"1234\", \"firstName\": \""+OTMCurrentUser.firstName+"\", \"lastName\": \""+OTMCurrentUser.lastName+"\",\"mapString\": \""+locationName+"\", \"mediaURL\": \""+mediaUrl+"\",\"latitude\": \(Double(student.latitude!)), \"longitude\": \(Double(student.longitude!))}"
        
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForFavorite(nil, error)
            } else {
                if let results = results?[OTMClient.JSONResponseKeys.StatusCode] as? Int {
                    completionHandlerForFavorite(results, nil)
                } else {
                    completionHandlerForFavorite(nil, NSError(domain: "postToFavoritesList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToFavoritesList"]))
                }
            }
        }
    }
    
    
}
