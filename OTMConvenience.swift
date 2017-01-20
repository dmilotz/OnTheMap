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
        let _ = taskForParseGETMethod(url: Constants.parseUrl) {(parsedResults, error) in
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
    
    
    func postStudents(_ student: OTMStudent, mediaUrl: String, locationName: String, completionHandlerForPostStudents: @escaping (_ result: Int?, _ error: NSError?) -> Void) {
        
        let jsonBody = "{\"uniqueKey\": \"" + OTMCurrentUser.userId + "\", \"firstName\": \""+OTMCurrentUser.firstName+"\", \"lastName\": \""+OTMCurrentUser.lastName+"\",\"mapString\": \""+locationName+"\", \"mediaURL\": \""+mediaUrl+"\",\"latitude\": \(Double(student.latitude!)), \"longitude\": \(Double(student.longitude!))}"
        
        
        /* 2. Make the request */
       // let _ = taskForPOSTMethod(jsonBody: jsonBody) { (results, error) in
        let _ = taskForParsePOSTMethod(url: Constants.parseUrl, jsonBody: jsonBody) {(results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPostStudents(nil, error)
            } else {
                if let results = results?[OTMClient.JSONResponseKeys.StatusCode] as? Int {
                    completionHandlerForPostStudents(results, nil)
                } else {
                    completionHandlerForPostStudents(nil, NSError(domain: "postToStudents parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudents"]))
                }
            }
        }
    }
    
//    func getCurrentStudent(_ completionHandlerForGetCurrentStudent: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
//        
//        
//        /* Make the request */
//        let _ = taskForUdacityGETMethod(url: Constants.udacityGetUserUrl) {(parsedResults, error) in
//            /* 3. Send to completion handler */
//            print(parsedResults)
//            if let error = error {
//                completionHandlerForGetCurrentStudent(nil, error)
//            } else {
//                /* GUARD: Is the "results" key in parsedResult? */
//                guard let results = parsedResults!["user"] as? [String:AnyObject] else {
//                    print("Cannot find key 'results' in \(parsedResults)")
//                    return
//                }
//                
//                
//                completionHandlerForGetCurrentStudent(results as AnyObject?, nil)
//                
//            }
//        }
//    }
    
    

    
    
    
}
