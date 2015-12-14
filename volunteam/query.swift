//query.swift

import UIKit
import MapKit
import AVFoundation


let user_id = rmw_user.shared_instance.id
enum query_type
{
        case get_event
        case register
        case log_in
        case get_events
        case create_event
        case get_user_profile
        case join_event
        
        func requires_coordinate() -> Bool
        {
                switch self
                {
                        //get
                case .get_events:
                        return true
                default:
                        return false
                }
        }
        
        var uses_event_id: Bool
        {
                return self == .join_event
        }
        
        var url_string: String!
                {
                        let base_string = "http://api.serveitup481.com/"
                        switch self
                        {
                        case .get_event:
                                return base_string + "get_event/" //need to get the specific id
                        case .get_events:
                                return base_string + "eventslist"//"eventslist"
                        case .log_in:
                                return base_string + "user/loginUser"
                        case .register:
                                return base_string + "users"
                        case .join_event:
                                return base_string + "/event/<event_id>/<user_id>"
                        case .create_event:
                                return base_string + "events"
                        case .get_user_profile:
                                return base_string + "user/" + String(user_id)
                        }
        }
        
        
        func url_with_event(id: Int) -> NSURL
        {
                let base_string = "http://api.eecs481volunteering1.appspot.com/"
                let full_string = base_string + "event/" + String(id) + "/" + String(user_id)
                return NSURL(string: full_string)!
        }
        
        var request_http_method: String
                {
                return "POST"
                /*if self == .get_events
                {
                        return "GET"
                }
                        else
                {
                        return "POST"
                }*/
        }
        
        var url: NSURL!
                {
                        return NSURL(string: self.url_string)
        }
}

protocol query_delegate: class
{
        func manage_response(response_query: query, _ response: Dictionary<String, AnyObject>)
        func failed_response(response_query: query)
}

class query: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate//: NSURLSessionDelegate
{
        //MARK: Member Variables
        
        weak var delegate: query_delegate?
        var type: query_type!
        var dictionary = Dictionary<String, AnyObject>()
        var should_query: Bool = true
        
        //MARK: Initializers\
        
        convenience init(_ type: query_type)
        {
                self.init()
                self.set_type(type)
        }
        
        override init()
        {
                super.init()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        
        func set_type(type: query_type)
        {
                self.type = type
                run_on_main_thread(
                        {
                                //indicator
                })
        }
        
        //MARK: Member Functions
        
        //func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void)
        func URLSession(session: NSURLSession,
                task: NSURLSessionTask,
                didReceiveChallenge challenge: NSURLAuthenticationChallenge,
                completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?)
                -> Void)
        {
                completionHandler(
                        NSURLSessionAuthChallengeDisposition.PerformDefaultHandling,
                        NSURLCredential(forTrust:
                                challenge.protectionSpace.serverTrust!))
        }
        
        //MARK: ec2
        
        
        
        func ec2_query()
        {
                if let request: NSURLRequest = create_ec2_request()
                {
                        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
                        if !should_query
                        {
                                //self.present_error("Error", "Something went wrong, and the query could not be made. Please check your network and location services.")
                                return
                        }
                        print("url: \(self.type.url)")
                        print("self dictionary: \(self.dictionary)")
                        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler:
                                {
                                        (data, response, error) in
                                        do
                                        {
                                                print("data: \(data)")
                                                if data == nil
                                                {
                                                        return
                                                }
                                                if let fresh_dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? Dictionary<String, AnyObject>
                                                {
                                                        print("fresh_dictionary: \(fresh_dictionary)")
                                                        run_on_background_thread
                                                                {
                                                                        self.delegate?.manage_response(self, fresh_dictionary)
                                                                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                                        }
                                                }
                                                //self.present_error("Oops")
                                        }
                                        catch _
                                        {
                                                print("error: \(error?.localizedDescription)")
                                                //self.present_error("Oops")
                                        }
                        })
                        task.resume()
                }
        }
        
        func create_ec2_request() -> NSMutableURLRequest?
        {
                self.add_extras()
                do
                {
                        let data = try NSJSONSerialization.dataWithJSONObject(self.dictionary, options: NSJSONWritingOptions())
                        let url: NSURL!
                        if self.type.uses_event_id
                        {
                                let event_id = self.dictionary["event_id"] as! Int
                                url = self.type.url_with_event(event_id)
                        }
                        else
                        {
                                url = self.type.url
                        }
                        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 15)
                        request.HTTPMethod = self.type.request_http_method
                        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                        request.HTTPBody = data
                        return request
                }
                catch _
                {
                        return nil
                }
        }
        
        //MARK: request helpers
        
        func add_extras()
        {
                
                //post parameters
                dictionary["version"] = "1.0"
                dictionary["security"] = self.security_dictionary()
        }
        
        func security_dictionary() -> NSDictionary!
        {
                let db_username = "localhost"
                let db_password = "yep"
                let dictionary = ["db_username": db_username, "db_password": db_password]
                return dictionary
        }
        
        func present_error(title: String, _ message: String = "uh oh")
        {
                /*if self.type == query_type.session_alaytic
                {
                        return
                }
                run_on_main_thread
                        {
                                self.finished_parsing()
                                if self.type == .read_chat || self.type == .read_discussion
                                {
                                        return
                                }
                                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                                if let view_controller = UIApplication.topViewController()
                                {
                                        view_controller.view.endEditing(true)
                                        view_controller.presentViewController(alert, animated: true, completion: nil)
                                }
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
                self.delegate?.failed_response(self)*/
        }
        
        //MARK: Delegate Methods
}