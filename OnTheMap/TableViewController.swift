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
    var students: [OTMStudent] = [OTMStudent]()
   
    
    @IBAction func createPin(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "EnterStudentInfoViewController") 
        self.present(controller, animated: true, completion: nil)
    }
    // MARK: Life Cycle
    
    @IBAction func refreshTable(_ sender: Any) {
        OTMClient.sharedInstance().getStudents { (students, error) in
            if let students = students{
                self.students = students
            }
            self.tableView.reloadData()
        }
        
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.parseRequest()
        super.viewWillAppear(animated)
        OTMClient.sharedInstance().getStudents { (students, error) in
            if let students = students{
                self.students = students
            }
            self.tableView.reloadData()
        }
    }

    private func displayAlert(_ message: String, title: String) {
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: title, message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        let student = self.students[(indexPath as NSIndexPath).row]
        if student.firstName == nil || student.lastName == nil{
             cell.textLabel?.text = "No Name Provided"}
        else{
        // Set the name and image
            
            cell.textLabel?.text = (student.firstName)! + " " + (student.lastName)!
        
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = self.students[(indexPath as NSIndexPath).row]
//        if student.mediaUrl != nil{
//            print(student.mediaUrl)
//            UIApplication.shared.openURL(URL(string: student.mediaUrl!)!)
//        }
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

//    //MARK: - ableViewController (UITableViewController)
//
//extension TableViewController {
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        // get cell type
//        let cellReuseIdentifier = "StudentTableViewCell"
//        let movie = movies[(indexPath as NSIndexPath).row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
//        
//        // set cell defaults
//        cell?.textLabel!.text = movie.title
//        cell?.imageView!.image = UIImage(named: "Film Icon")
//        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
//    
//        return cell!
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return movies.count
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        // push the movie detail view
//        let controller = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
//        controller.movie = movies[(indexPath as NSIndexPath).row]
//        navigationController!.pushViewController(controller, animated: true)
//    }
//    
//    
//}

