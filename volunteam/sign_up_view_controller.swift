//
//  sign_up_view_controller.swift
//  volunvarm
//
//  Created by Ryan Wolande on 12/13/15.
//  Copyright © 2015 Ryan Wolande. All rights reserved.
//

class sign_up_view_controller: UIViewController, query_delegate
{
        var sign_up_label: rmw_label!
        var underline: UIView!
        var sign_in_label: rmw_label!
        var first_name_field: rmw_pop_up_text_field!
        var last_name_field: rmw_pop_up_text_field!
        var email_field: rmw_pop_up_text_field!
        var zipcode_field: rmw_pop_up_text_field!
        var password_field: rmw_pop_up_text_field!
        var confirm_password_field: rmw_pop_up_text_field!
        var sign_up_button: UIButton!
        var signing_up: Bool?
        {
                didSet
                {
                        if signing_up != nil
                        {
                                if signing_up!
                                {
                                        sign_up_label.textColor = UIColor.soft_blue()
                                        sign_in_label.textColor = UIColor.medium_gray()
                                        first_name_field.alpha = 1
                                        first_name_field.frame.origin.y = sign_up_label.frame.y_end + post_padding
                                        last_name_field.frame.origin.y = first_name_field.frame.y_end + post_padding
                                        email_field.frame.origin.y = last_name_field.frame.y_end + post_padding
                                        zipcode_field.frame.origin.y = email_field.frame.y_end + post_padding
                                        password_field.frame.origin.y = zipcode_field.frame.y_end + post_padding
                                        confirm_password_field.frame.origin.y = password_field.frame.y_end + post_padding
                                        sign_up_button.setTitle("sign up", forState: UIControlState.Normal)
                                        underline.frame.origin.x = sign_up_label.frame.origin.x
                                }
                                else
                                {
                                        sign_up_label.textColor = UIColor.medium_gray()
                                        sign_in_label.textColor = UIColor.soft_blue()
                                        first_name_field.alpha = 0
                                        email_field.frame.origin.y = sign_up_label.frame.y_end + post_padding
                                        password_field.frame.origin.y = email_field.frame.y_end + post_padding
                                        sign_up_button.setTitle("sign in", forState: UIControlState.Normal)
                                        underline.frame.origin.x = sign_in_label.frame.origin.x
                                }
                                
                                last_name_field.alpha = first_name_field.alpha
                                zipcode_field.alpha = first_name_field.alpha
                                confirm_password_field.alpha = first_name_field.alpha
                        }
                }
        }
        
        override func viewDidLoad()
        {
                super.viewDidLoad()
                
                sign_up_label = rmw_label(string: "sign up", font: UIFont.systemFontOfSize(14), frame: CGRectMake(self.view.golden_inset_x, status_bar_height(), self.view.frame.size.width/2 - self.view.golden_inset_x, flat_height))
                sign_up_label.textColor = UIColor.tony_gray()
                sign_up_label.textAlignment = .Center
                sign_up_label.userInteractionEnabled = true
                sign_up_label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "begin_sign_up"))
                self.view.addSubview(sign_up_label)
                
                sign_in_label = rmw_label(string: "sign in", font: UIFont.systemFontOfSize(14), frame: sign_up_label.frame)
                sign_in_label.frame.origin.x = sign_up_label.frame.x_end
                sign_in_label.textColor = UIColor.soft_blue()
                sign_in_label.textAlignment = .Center
                sign_in_label.userInteractionEnabled = true
                sign_in_label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "begin_sign_in"))
                self.view.addSubview(sign_in_label)
                
                underline = UIView(frame: CGRectMake(sign_up_label.frame.origin.x, sign_up_label.frame.y_end - border_thin_length, sign_up_label.frame.size.width, border_thin_length))
                underline.backgroundColor = UIColor.soft_blue()
                self.view.addSubview(underline)
                
                first_name_field = rmw_pop_up_text_field(frame: CGRectMake(self.view.golden_inset_x, sign_up_label.frame.y_end, self.view.golden_width, flat_height), pop_up_string: "first name")
                first_name_field.field.set_placeholder("first name")
                self.view.addSubview(first_name_field)
                
                last_name_field = rmw_pop_up_text_field(frame: first_name_field.frame, pop_up_string: "last name")
                last_name_field.field.set_placeholder("last name")
                last_name_field.frame.origin.y = first_name_field.frame.y_end + post_padding
                self.view.addSubview(last_name_field)
                
                email_field = rmw_pop_up_text_field(frame: first_name_field.frame, pop_up_string: "email address")
                email_field.field.set_placeholder("email address")
                email_field.frame.origin.y = last_name_field.frame.y_end + post_padding
                self.view.addSubview(email_field)
                
                zipcode_field = rmw_pop_up_text_field(frame: email_field.frame, pop_up_string: "zip code")
                zipcode_field.field.set_placeholder("zip code")
                zipcode_field.frame.origin.y = email_field.frame.y_end + post_padding
                self.view.addSubview(zipcode_field)
                
                password_field = rmw_pop_up_text_field(frame: zipcode_field.frame, pop_up_string: "password")
                password_field.field.set_placeholder("password")
                password_field.field.secureTextEntry = true
                password_field.frame.origin.y = zipcode_field.frame.y_end + post_padding
                self.view.addSubview(password_field)
                
                confirm_password_field = rmw_pop_up_text_field(frame: password_field.frame, pop_up_string: "confirm password")
                confirm_password_field.field.set_placeholder("confirm")
                confirm_password_field.field.secureTextEntry = true
                confirm_password_field.frame.origin.y = password_field.frame.y_end + post_padding
                self.view.addSubview(confirm_password_field)
                
                let sign_up_border = UIView(frame: CGRect.zero(self.view.frame.size.width, border_thin_length))
                sign_up_border.backgroundColor = UIColor.warm_blue()
                
                sign_up_button = UIButton(frame: CGRectMake(0, self.view.frame.size.height - flat_height, self.view.frame.size.width, flat_height))
                sign_up_button.backgroundColor = UIColor.soft_blue()
                sign_up_button.setTitle("sign up", forState: UIControlState.Normal)
                sign_up_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                sign_up_button.addTarget(self, action: "sign_up", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(sign_up_button)
                sign_up_button.addSubview(sign_up_border)
                
                signing_up = true
        }
        
        func begin_sign_up()
        {
                self.view.animate_spring(
                {
                        self.signing_up = true
                })
        }
        
        func begin_sign_in()
        {
                self.view.animate_spring(
                        {
                                self.signing_up = false
                })
        }
        
        func sign_up()
        {
                if signing_up != nil
                {
                        if signing_up!
                        {
                                let sign_up_query = query(.register)
                                sign_up_query.dictionary["first_name"] = first_name_field.field.text
                                sign_up_query.dictionary["last_name"] = last_name_field.field.text
                                sign_up_query.dictionary["email"] = email_field.field.text
                                sign_up_query.dictionary["zipcode"] = zipcode_field.field.text
                                sign_up_query.dictionary["password"] = password_field.field.text
                                sign_up_query.dictionary["confirm"] = confirm_password_field.field.text
                                sign_up_query.delegate = self
                                sign_up_query.ec2_query()
                        }
                        else
                        {
                                let sign_in_query = query(.log_in)
                                sign_in_query.dictionary["email"] = email_field.field.text
                                sign_in_query.dictionary["password"] = password_field.field.text
                                sign_in_query.delegate = self
                                sign_in_query.ec2_query()
                        }
                }
        }
        
        func manage_response(response_query: query, _ response: Dictionary<String, AnyObject>)
        {
                if let raw_user = response["user"] as? Dictionary<String,AnyObject>
                {
                        if let user = rmw_user(raw: raw_user)
                        {
                                rmw_user.shared_instance = user
                        }
                }
                run_on_main_thread(
                {
                        (UIApplication.sharedApplication().delegate as! AppDelegate).assign_root_as_tab()
                })
        }
        
        func failed_response(response_query: query)
        {
                
        }
}