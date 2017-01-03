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
    var pins: [Pin] = [Pin]()
   
    
    @IBAction func createPin(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "EnterLocationViewController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
    // MARK: Life Cycle
    
    @IBAction func refreshTable(_ sender: Any) {
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
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

