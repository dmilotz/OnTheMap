//
//  OnTheMapClient.swift
//


import Foundation
import UIKit
// MARK: - OnTheMapClient: NSObject

class OTMClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    func udacityLogin(_ userName: String, password: String,   completionHandlerLogin: @escaping (_ result: AnyObject?, _ error: String?) -> Void) {
        
        
        let jsonBody  = "{\"udacity\": {\"username\":\"" + userName + "\", \"password\": \"" + password + "\"}}"
        
        let request = NSMutableURLRequest(url: URL(string: OTMClient.Constants.udacityLoginUrl)!)
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            
            func sendError(_ error: String) {
                print(error)
                completionHandlerLogin(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            switch statusCode!{
            case 400:
                    sendError("Bad request.")
            case 401:
                    sendError("Username or password are wrong.  Please try again.")
            case 403:
                    sendError("Username or password are wrong.  Please try again.")
            case 404:
                    sendError("Server not found. Please check the url and try again.")
            default:break
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            
            let convertedData = (NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult = String(convertedData)
            
            //Udacity server returning garbage characters......
            
            parsedResult = parsedResult.replacingOccurrences(of: ")]}'", with: "")
            
            let dict = self.convertToDictionary(text: parsedResult)
            
            
            completionHandlerLogin(dict as AnyObject?, nil)
        }
        task.resume()
        
    }
    
    
    
    func getUdacityStudentInfo( url : String, completionHandlerForGetStudent: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        /* 1. Set the parameters */
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGetStudent(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let convertedData = (NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult = String(convertedData)
            
            //Udacity server returning garbage characters......
            
            parsedResult = parsedResult.replacingOccurrences(of: ")]}'", with: "")
            
            let dict = self.convertToDictionary(text: parsedResult)
            
            completionHandlerForGetStudent(dict as AnyObject? , nil)
            
            
        }
        task.resume()
    }
    
    func logoutFromUdacity(completionHandlerLogout: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void){
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range) /* subset response data! */
            completionHandlerLogout(newData as AnyObject?, error as NSError?)
        }
        task.resume()
        
    }
    
    
    
    func taskForParseGETMethod( url : String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey : [String:Any] = [:]
        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.addValue(Constants.appId, forHTTPHeaderField: Constants.appIdHeader)
        request.addValue(Constants.apiKey, forHTTPHeaderField: Constants.apiKeyHeader)
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            completionHandlerForGET(parsedResult as AnyObject?, nil)
            
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForParsePOSTMethod(url: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey : [String:Any] = [:]
        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        //        let request = NSMutableURLRequest(url:parseURLFromParameters(parametersWithApiKey as [String : AnyObject]))
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue(Constants.appId, forHTTPHeaderField: Constants.appIdHeader)
        request.addValue(Constants.apiKey, forHTTPHeaderField: Constants.apiKeyHeader)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            
            
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    
    //
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = OTMClient.Constants.ApiScheme
        components.host = OTMClient.Constants.ApiHost
        components.path = OTMClient.Constants.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print(components)
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
}
