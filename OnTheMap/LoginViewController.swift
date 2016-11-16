

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    // MARK: Life Cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // get the app delegate
//        appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        configureUI()
//        
//        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
//        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
//        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
//        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        unsubscribeFromAllNotifications()
//    }
//    
//    // MARK: Login
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
        } else {
            let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
            let user = String(usernameTextField.text!)
            let pass = String(passwordTextField.text!)
            let postString  = "{\"udacity\": {\"username\":\"" + user! + "\", \"password\": \"" + pass! + "\"}}"
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let session = URLSession.shared
            print(postString)
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil { // Handle error…
                    return
                }
                let range = Range(uncheckedBounds: (5, data!.count - 5))
                let newData = data?.subdata(in: range) /* subset response data! */
                print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            }
            task.resume()
                     
        }
    }

}
