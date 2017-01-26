//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Dirk Milotz on 1/11/17.
//  Copyright © 2017 Dirk Milotz. All rights reserved.
//

import Foundation
extension OTMClient{
    
    func getStudents(_ completionHandlerForGetStudents: @escaping ( _ error: NSError?) -> Void) {
        
        
        /* Make the request */
        let _ = taskForParseGETMethod(url: Constants.parseUrl) {(parsedResults, error) in
            /* 3. Send to completion handler */
            if let error = error {
                completionHandlerForGetStudents( error)
            } else {
                /* GUARD: Is the "results" key in parsedResult? */
                guard let results = parsedResults!["results"] as? [[String:AnyObject]] else {
                    return
                }
                    StudentDataSource.sharedInstance.studentData = OTMStudent.studentsFromResults(results)
//                    StudentsModel.setStudentsFromResults(results)
                    completionHandlerForGetStudents( nil)
               
            }
        }
    }

    
    
    
}
