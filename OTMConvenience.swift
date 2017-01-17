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
        let _ = taskForGETMethod() {(parsedResults, error) in
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
        
        let jsonBody = "{\"uniqueKey\": \"1234\", \"firstName\": \""+OTMCurrentUser.firstName+"\", \"lastName\": \""+OTMCurrentUser.lastName+"\",\"mapString\": \""+locationName+"\", \"mediaURL\": \""+mediaUrl+"\",\"latitude\": \(Double(student.latitude!)), \"longitude\": \(Double(student.longitude!))}"
        
        
        /* 2. Make the request */
       // let _ = taskForPOSTMethod(jsonBody: jsonBody) { (results, error) in
        let _ = taskForPOSTMethod(url: Constants.parseUrl, jsonBody: jsonBody) {(results, error) in
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
    
    
//        let task = session.dataTask(with: request as URLRequest) { data, response, error in
//
//            func displayError(_ error: String) {
//                print(error)
//                self.debugTextLabel.text = "Login Failed (Request Token)."
//                
//            }
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                displayError("There was an error with your request: \(error)")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                displayError("Your request returned a status code other than 2xx!")
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                displayError("No data was returned by the request!")
//                return
//            }
//            
//            let range = Range(uncheckedBounds: (5, data.count - 5))
//            let newData = data.subdata(in: range)  /* subset response data! */
//            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
//            self.completeLogin()
//        }
//        task.resume()
//        
//    }

//        let jsonBody = "{\"uniqueKey\": \"1234\", \"firstName\": \""+OTMCurrentUser.firstName+"\", \"lastName\": \""+OTMCurrentUser.lastName+"\",\"mapString\": \""+locationName+"\", \"mediaURL\": \""+mediaUrl+"\",\"latitude\": \(Double(student.latitude!)), \"longitude\": \(Double(student.longitude!))}"
//        
//        
//        /* 2. Make the request */
//        let _ = taskForPOSTMethod(jsonBody: jsonBody) { (results, error) in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                completionHandlerForPostStudents(nil, error)
//            } else {
//                if let results = results?[OTMClient.JSONResponseKeys.StatusCode] as? Int {
//                    completionHandlerForPostStudents(results, nil)
//                } else {
//                    completionHandlerForPostStudents(nil, NSError(domain: "postToStudents parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudents"]))
//                }
//            }
//        }
    
    
    
}
