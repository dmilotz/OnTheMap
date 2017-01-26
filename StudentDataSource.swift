//
//  StudentDataSource.swift
//  OnTheMap
//
//  Created by Dirk Milotz on 1/25/17.
//  Copyright © 2017 Dirk Milotz. All rights reserved.
//

import Foundation
class StudentDataSource {
    var studentData = [OTMStudent]()
    static let sharedInstance = StudentDataSource()
    private init() {} 
}
