//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Dirk Milotz on 1/2/17.
//  Copyright © 2017 Dirk Milotz. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!   
    
    @IBAction func createPin(_ sender: Any) {
        
        if (userPinExists()){
            self.displayOverwriteAlert()
        }
        else{
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "EnterStudentInfoViewController")
        self.present(controller, animated: true, completion: nil)
        }
    }
    // MARK: Life Cycle
    
    @IBAction func refreshTable(_ sender: Any) {
        getStudents()
    }
    
    @IBAction func logout(_ sender: Any) {
            OTMClient.sharedInstance().logoutFromUdacity(completionHandlerLogout: { (results, error) in
                if (error != nil){
                    self.displayAlert(String(describing: error), title: "Problem logging out")
                    return
                }
                OperationQueue.main.addOperation {

                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                }
            })
        }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudents()
    }

    
    func getStudents(){
        OTMClient.sharedInstance().getStudents { (error) in
            if(error != nil){
                self.displayAlert("Failed to download student data.", title:"Error")
                return
            }
            else{
                self.tableView.reloadData()

            }
        }
        
        
    }
    
    func userPinExists()-> Bool{
        for student in StudentDataSource.sharedInstance.studentData{
            if student.firstName == OTMCurrentUser.firstName && student.lastName == OTMCurrentUser.lastName{
                return true
            }
            else{
                return false
            }
        }
        
        return false
        
    }
    


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentDataSource.sharedInstance.studentData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        let student = StudentDataSource.sharedInstance.studentData[(indexPath as NSIndexPath).row]
        if student.firstName == nil || student.lastName == nil{
             cell.textLabel?.text = "No Name Provided"}
        else{
        // Set the name and image
            
            cell.textLabel?.text = (student.firstName)! + " " + (student.lastName)!
        
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentDataSource.sharedInstance.studentData[(indexPath as NSIndexPath).row]

        if let url = URL(string: student.mediaUrl!){
            UIApplication.shared.openURL(url)
        }
        else{
            let alertController = UIAlertController(title: "noMediaUrlAlert", message:
                "No Url was Provided", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }

        
    }
    
}

