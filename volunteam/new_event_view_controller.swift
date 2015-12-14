//
//  new_event_view_controller.swift
//  volunteam
//
//  Created by Ryan Wolande on 11/16/15.
//  Copyright © 2015 Ryan Wolande. All rights reserved.
//

import UIKit
import Alamofire

class event_preview_view: UIView
{
        var title_label: rmw_label!
        var message_label: rmw_label!
        var start_date_label: rmw_label!
        var ratio_view: rmw_event_ratio_view!
        var border: UIView!
        var image_view: UIImageView!
        
        override init(frame: CGRect)
        {
                super.init(frame: frame)
                image_view = UIImageView(frame: CGRectMake(padding, padding, events_cell_height/4, events_cell_height / 4))
                image_view.make_circle()
                image_view.layer.borderWidth = 1
                image_view.layer.borderColor = UIColor.concrete().CGColor
                image_view.image = UIImage(named: "volunteam")
                self.addSubview(image_view)
                
                title_label = rmw_label()
                title_label.frame = CGRectMake(image_view.frame.x_end + padding, padding, screen_size().width/golden_ratio, events_cell_height/4)
                title_label.textAlignment = .Left
                title_label.textColor = .tony_gray()
                self.addSubview(title_label)
                
                message_label = rmw_label()
                message_label.frame = CGRectMake(padding, events_cell_height/4, self.title_label.frame.size.width, events_cell_height/2 - padding)
                message_label.textAlignment = .Left
                message_label.font = UIFont.systemFontOfSize(14)
                self.addSubview(message_label)
                
                ratio_view = rmw_event_ratio_view(frame: CGRectMake(screen_size().width * 9/12 - padding, events_cell_height/6, screen_size().width / 4 - padding, events_cell_height * 2/3))
                self.addSubview(ratio_view)
                
                start_date_label = rmw_label()
                start_date_label.frame = CGRectMake(self.message_label.frame.origin.x, message_label.frame.y_end + padding, self.title_label.frame.size.width, events_cell_height - message_label.frame.y_end)
                start_date_label.textAlignment = .Left
                start_date_label.font = UIFont.systemFontOfSize(12)
                self.addSubview(start_date_label)
                
                border = UIView(frame: CGRectMake(0, events_cell_height-1, screen_size().width, 1))
                border.backgroundColor = UIColor.concrete()
                self.addSubview(border)
        }
        
        required init?(coder aDecoder: NSCoder)
        {
                super.init(coder: aDecoder)
        }
        
        //MARK: Member Functions
        
        func update(event: rmw_event)
        {
                title_label.text = event.name
                message_label.text = event.description
                //title_label.trim_height(false)
                title_label.frame.origin.y = padding
                //message_label.trim_height(false)
                message_label.frame.origin.y = title_label.frame.y_end + post_padding
                start_date_label.text = "starts " + event.start_date
                ratio_view.update(event.current_volunteer_count, quota: event.wanted_volunteer_count)
                self.update_image(event.image_url)
        }
        
        func update_image(url: String)
        {
                if let url = rmw_user.shared_instance.image_url
                {
                        Alamofire.request(.GET, url).response() {
                                (_, _, data, _) in
                                let image = UIImage(data: data!)
                                self.image_view.image = image
                        }
                }
        }
}

class volunteers_table_view: rmw_table_view
{
        
}

class rmw_address_view: UIView
{
        var organization_label: rmw_label!
        var street_label: rmw_label!
        var state_label: rmw_label!
        var zip_label: rmw_label!
        
        override init(frame: CGRect)
        {
                super.init(frame: frame)
                organization_label = rmw_label()
                organization_label.frame = CGRectMake(padding, padding, self.frame.size.width, self.frame.size.height / 4)
                organization_label.textAlignment = .Left
                organization_label.textColor = .tony_gray()
                self.addSubview(organization_label)
                
                street_label = rmw_label()
                street_label.frame = CGRectMake(padding, organization_label.frame.y_end, self.frame.size.width, self.frame.size.height / 4)
                street_label.textAlignment = .Left
                street_label.textColor = .medium_gray()
                self.addSubview(street_label)
                
                state_label = rmw_label()
                state_label.frame = CGRectMake(padding, street_label.frame.y_end, self.frame.size.width, self.frame.size.height / 4)
                state_label.textAlignment = .Left
                state_label.textColor = .medium_gray()
                self.addSubview(state_label)
                
                zip_label = rmw_label()
                zip_label.frame = CGRectMake(padding, state_label.frame.y_end, self.frame.size.width, self.frame.size.height / 4 - padding)
                zip_label.textAlignment = .Left
                zip_label.textColor = .medium_gray()
                self.addSubview(zip_label)
        }
        
        func update(event: rmw_event)
        {
                organization_label.text = "Hosted by: " + event.organization
                street_label.text = event.street_address
                state_label.text = event.state
                zip_label.text = event.zip
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}

class full_event_view_controller: UIViewController, query_delegate
{
        var id: Int!
        var event: rmw_event!
                {
                didSet
                {
                        preview_view.update(event)
                }
        }
        var preview_view: event_preview_view!
        var address_view: rmw_address_view!
        var table_view: volunteers_table_view!
        var join_button: UIButton!
        
        init(id: Int)
        {
                self.id = id
                super.init(nibName: nil, bundle: nil)
        }
        
        init(event: rmw_event)
        {
                self.id = event.id
                super.init(nibName: nil, bundle: nil)
                self.event = event
        }
        
        override func viewDidLoad()
        {
                super.viewDidLoad()
                self.view.backgroundColor = UIColor.white_smoke()
                preview_view = event_preview_view(frame: CGRectMake(0, self.navigationController!.navigationBar.frame.y_end, self.view.frame.size.width, events_cell_height))
                preview_view.update(event)
                self.view.addSubview(preview_view)
                
                address_view = rmw_address_view(frame: CGRectMake(0, preview_view.frame.y_end, self.view.frame.size.width, 80))
                address_view.update(event)
                self.view.addSubview(address_view)
                
                //table_view = volunteers_table_view(frame: CGRectMake(0, preview_view.frame.y_end, self.view.frame.size.width, self.view.frame.size.height - preview_view.frame.y_end))
                //self.view.addSubview(table_view)
        }
        
        override func viewWillAppear(animated: Bool)
        {
                super.viewWillAppear(animated)
                if join_button == nil
                {
                        join_button = UIButton(frame: CGRectMake(self.view.frame.size.width - 70, 7, 60, 30))
                        join_button.setTitle("join", forState: UIControlState.Normal)
                        join_button.setTitleColor(UIColor.concrete(), forState: UIControlState.Normal)
                        join_button.addTarget(self, action: "join_event", forControlEvents: UIControlEvents.TouchUpInside)
                }
                self.navigationController!.navigationBar.addSubview(join_button)
        }
        
        override func viewWillDisappear(animated: Bool)
        {
                super.viewWillDisappear(animated)
                join_button?.removeFromSuperview()
        }
        
        func join_event()
        {
                let join_query = query(query_type.join_event)
                join_query.dictionary["event_id"] = event.id
                join_query.delegate = self
                join_query.ec2_query()
        }
        
        func manage_response(response_query: query, _ response: Dictionary<String, AnyObject>)
        {
                let alert = UIAlertController(title: "Success", message: "You're in the Event! Have fun!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler:
                        {
                                action in
                }))
                run_on_main_thread(
                {
                         self.presentViewController(alert, animated: true, completion: nil)
                })
        }
        
        func failed_response(response_query: query)
        {
                
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}

class new_event_view_controller: UIViewController, query_delegate
{
        var main_view: new_event_view!
        var back_button: UIButton!
        override func viewDidLoad()
        {
                super.viewDidLoad()
                self.view.backgroundColor = UIColor.white_smoke()
                main_view = new_event_view(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
                main_view.submit_button.addTarget(self, action: "create_event", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(main_view)
                
                back_button = UIButton(frame: CGRectMake(self.view.frame.size.width - (20 + padding), padding + status_bar_height(), 20, 20))
                back_button.setTitle("x", forState: UIControlState.Normal)
                back_button.setTitleColor(UIColor.tony_gray(), forState: UIControlState.Normal)
                back_button.addTarget(self, action: "pop", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(back_button)
        }
        
        func pop()
        {
                self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        func create_event()
        {
                /*
                "close_date": "11/20/2015", //
                "organization": "U of M", //
                "skills":["skill1","skill2","skill3","skill4","skill5"],
                "creator_id": "5",
                "full_desc": "This is the long description",
                "end_date": "11/20/2015",
                "max_volunteers": "24",
                "event_name": "My Event", //
                "short_desc": "This is the short description",
                "start_date": "11/20/2015",
                "street_addr":"123 Baits Dr", //
                "city":"Ann Arbor", -
                "state":"MI", -
                "zipcode":"48108" //
                */
                let create_query = query(query_type.create_event)
                create_query.dictionary["creator_id"] = user_id
                create_query.dictionary["skills"] = ["skill1","skill2","skill3","skill4","skill5"]
                create_query.dictionary["organization"] = main_view.company_name_field.field.text
                create_query.dictionary["event_name"] = main_view.event_name_field.field.text
                create_query.dictionary["short_desc"] = main_view.description_field.text
                
                create_query.dictionary["full_desc"] = main_view.description_field.text
                create_query.dictionary["street_addr"] = main_view.location_field.field.text
                create_query.dictionary["zipcode"] = main_view.zip_field.field.text
                create_query.dictionary["max_volunteers"] = main_view.number_needed_field.field.text
                let end_date_string = main_view.date_field_month.field.text! + "/" + main_view.date_field_day.field.text! + "/" + main_view.date_field_year.field.text!
                create_query.dictionary["end_date"] = end_date_string
                create_query.dictionary["close_date"] = end_date_string
                create_query.ec2_query()
        }
        
        func manage_response(response_query: query, _ response: Dictionary<String, AnyObject>)
        {
                self.pop()
        }
        
        func failed_response(response_query: query)
        {
                
        }
}


enum event_category
{
        case Homelessness
        case Education
        case ManualLabor
        case Religious
        case CommunityCleanUp
        case Other
        
        func string_representation() -> String
        {
                switch self
                {
                case .Homelessness:
                        return "Homelessness"
                case .ManualLabor:
                        return "Manual Labor"
                case .Education:
                        return "Education"
                case .Religious:
                        return "Religious"
                case .CommunityCleanUp:
                        return "CommunityCleanUp"
                case .Other:
                        return "Other"
                }
        }
}
class new_event_view: UIScrollView, text_delegate
{
        //var image_view: UIImageView!
        
        //name of company/org
        var company_name_field: rmw_pop_up_text_field!
        
        //event name
        var event_name_field: rmw_pop_up_text_field!
        
        //description
        var description_field: rmw_text_view!
        var character_count_label: rmw_label!
        
        //location (address and zip)
        var location_field: rmw_pop_up_text_field!
        var zip_field: rmw_pop_up_text_field!
        
        //date of event
        var date_field_month: rmw_pop_up_text_field!
        var date_field_day: rmw_pop_up_text_field!
        var date_field_year: rmw_pop_up_text_field!
        
        //start time
        
        //end time
        
        var new_skill_fields = [rmw_pop_up_text_field]()
        
        //category
        //var category_picker
        //number needed
        
        var number_needed_field: rmw_pop_up_text_field!
        
        //submit button (Create Event)
        var submit_button: UIButton!
        
        override init(frame: CGRect)
        {
                super.init(frame: frame)
                self.backgroundColor = UIColor.whiteColor()
                
                company_name_field = rmw_pop_up_text_field(frame: CGRectMake(padding, status_bar_height() + padding, self.frame.size.width - padding * 2, field_height), pop_up_string: "company name")
                company_name_field.field.set_placeholder("company name")
                self.addSubview(company_name_field)
                
                event_name_field = rmw_pop_up_text_field(frame: CGRectMake(padding, company_name_field.frame.y_end + padding, self.frame.size.width - padding * 2, field_height), pop_up_string: "event name")
                event_name_field.field.set_placeholder("event name")
                self.addSubview(event_name_field)
                
                description_field = rmw_text_view(frame: CGRectMake(padding, event_name_field.frame.y_end + padding, self.frame.size.width - padding * 2, field_height * 3))
                description_field.text_protocol = self
                //description_field.set_placeholder("description")
                description_field.textAlignment = .Left
                description_field.layer.cornerRadius = 4
                description_field.clipsToBounds = true
                description_field.layer.borderWidth = 1
                description_field.layer.borderColor = UIColor.border_gray().CGColor
                description_field.character_limit = 500
                self.addSubview(description_field)
                
                character_count_label = rmw_label(frame: CGRectMake(self.description_field.frame.size.width-40, post_padding, 36, 36))
                character_count_label.textColor = UIColor.medium_gray()
                character_count_label.text = "500"
                character_count_label.align_above(description_field.frame.size.height)
                self.description_field.addSubview(character_count_label)
                
                location_field = rmw_pop_up_text_field(frame: CGRectMake(padding, description_field.frame.y_end + padding, self.frame.size.width - padding * 2, field_height), pop_up_string: "street address")
                location_field.field.set_placeholder("street address")
                self.addSubview(location_field)
                
                zip_field = rmw_pop_up_text_field(frame: CGRectMake(padding, location_field.frame.y_end + padding, self.frame.size.width - padding * 2, field_height), pop_up_string: "zip code")
                zip_field.field.set_placeholder("zip code")
                self.addSubview(zip_field)
                
                let date_width = (self.frame.size.width - padding * 4) / 3
                date_field_month = rmw_pop_up_text_field(frame: CGRectMake(padding, zip_field.frame.y_end + padding, date_width, 40), pop_up_string: "mt")
                date_field_month.field.set_placeholder("mt")
                date_field_month.field.character_limit = 2
                self.addSubview(date_field_month)
                
                date_field_day = rmw_pop_up_text_field(frame: CGRectMake(date_field_month.frame.x_end + padding, date_field_month.frame.origin.y, date_width, date_field_month.frame.size.height), pop_up_string: "dy")
                date_field_day.field.set_placeholder("dy")
                date_field_day.field.character_limit = 2
                self.addSubview(date_field_day)
                
                date_field_year = rmw_pop_up_text_field(frame: CGRectMake(date_field_day.frame.x_end + padding, date_field_month.frame.origin.y, date_width, date_field_month.frame.size.height), pop_up_string: "year")
                date_field_year.field.set_placeholder("year")
                date_field_year.field.character_limit = 4
                self.addSubview(date_field_year) // send this guy: /
                
                number_needed_field = rmw_pop_up_text_field(frame: CGRectMake(padding, date_field_day.frame.y_end + padding, self.frame.size.width - padding * 2, field_height), pop_up_string: "quota")
                number_needed_field.field.set_placeholder("volunteer quota")
                self.addSubview(number_needed_field)
                
                submit_button = UIButton(frame: CGRectMake(padding, number_needed_field.frame.y_end + padding, self.frame.size.width, field_height))
                submit_button.setTitleColor(UIColor.dark_gray(), forState: UIControlState.Normal)
                submit_button.setTitle("create event", forState: UIControlState.Normal)
                self.addSubview(submit_button)
                
                self.contentSize.height = submit_button.frame.y_end
                
        }
        
        func text_changed(text: String, _ tag: Int)
        {
                self.character_count_label.text = String(500 - text.length())
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}

class rmw_date_view: UIView
{
        var month_field: rmw_text_field!
        var date_field: rmw_text_field!
        var number_field: rmw_text_field!
        override init(frame: CGRect)
        {
                super.init(frame: frame)
                self.backgroundColor = UIColor.clearColor()
                
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}