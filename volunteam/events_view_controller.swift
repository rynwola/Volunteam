import UIKit

class events_view_controller: UIViewController, query_delegate, rmw_event_delegate
{
        var table_view: events_table_view!
        var add_button: UIButton!
        override func viewDidLoad()
        {
                super.viewDidLoad()
                table_view = events_table_view(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), with_search_bar: true, event_delegate: self)
                self.view.addSubview(table_view)
                run_on_main_thread(
                        {
                         self.table_view.reloadData()
                                })
                

                
                let events_query = query(.get_events)
                events_query.delegate = self
                events_query.ec2_query()
        }
        
        override func viewWillAppear(animated: Bool)
        {
                super.viewWillAppear(animated)
                if add_button == nil
                {
                        add_button = UIButton(frame: CGRectMake(self.view.frame.size.width - 70, 7, 60, 30))
                        add_button.setTitle("new", forState: UIControlState.Normal)
                        add_button.setTitleColor(UIColor.concrete(), forState: UIControlState.Normal)
                        add_button.addTarget(self, action: "create_event", forControlEvents: UIControlEvents.TouchUpInside)
                }
                self.navigationController!.navigationBar.addSubview(add_button)
        }
        
        override func viewWillDisappear(animated: Bool)
        {
                super.viewWillDisappear(animated)
                add_button?.removeFromSuperview()
        }
        
        func expand_event(event: rmw_event)
        {
                self.navigationController!.pushViewController(full_event_view_controller(event: event), animated: true)
        }
        
        func manage_response(response_query: query, _ response: Dictionary<String, AnyObject>)
        {
                
                print("response: \(response)")
                if let raw_events = response["events"] as? [Dictionary<String, AnyObject>]
                {
                        var events = rmw_ordered_map<Int,rmw_event>()
                        for raw_event in raw_events
                        {
                                if let event = rmw_event(raw: raw_event)
                                {
                                        events[event.id] = event
                                }
                        }
                        run_on_main_thread(
                        {
                                self.table_view.events = events
                                self.table_view.reloadData()
                                //response_query

                        })
                }
        }
        
        func failed_response(response_query: query)
        {
                
        }
        
        func create_event()
        {
                self.presentViewController(new_event_view_controller(), animated: true, completion: nil)
        }
}

protocol rmw_event_delegate: class
{
        func expand_event(event: rmw_event)
}

class user_events_table_view: events_table_view
{
        override init(frame: CGRect, with_search_bar: Bool, event_delegate: rmw_event_delegate)
        {
                super.init(frame: frame, with_search_bar: with_search_bar, event_delegate: event_delegate)
                
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
                if section == 0
                {
                        return rmw_user.shared_instance.created_events.count
                }
                else if section == 1
                {
                        return rmw_user.shared_instance.upcoming_events.count
                }
                else
                {
                        return rmw_user.shared_instance.recent_events.count
                }
        }
        
        func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
        {
                return 40
        }
        
        func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
        {
                let label = rmw_label(frame: CGRectMake(padding, padding, self.frame.size.width - padding * 2, 40 - padding * 2))
                label.textColor = UIColor.dark_gray()
                label.font = UIFont.systemFontOfSize(14, weight: 1)
                if section == 0
                {
                        label.text = rmw_user.shared_instance.first_name + "'s created events (" + String(rmw_user.shared_instance.created_events.count) + ")"
                }
                else if section == 1
                {
                        label.text = rmw_user.shared_instance.first_name + "'s upcoming events (" + String(rmw_user.shared_instance.upcoming_events.count) + ")"
                }
                else
                {
                        label.text = rmw_user.shared_instance.first_name + "'s recent events (" + String(rmw_user.shared_instance.recent_events.count) + ")"
                }
                let view = UIView(frame: CGRect.zero(self.frame.size.width, 40))
                view.addSubview(label)
                
                let border = UIView(frame: CGRectMake(0, 40-border_thin_length, self.frame.size.width, border_thin_length))
                border.backgroundColor = UIColor.border_gray()
                view.addSubview(border)
                return view
        }
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int
        {
                return 3
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        {
                if events.count == 0
                {
                        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
                }
                var cell = self.dequeueReusableCellWithIdentifier(event_cell_identifier, forIndexPath: indexPath) as? event_cell
                if (cell == nil)
                {
                        cell = event_cell(style: .Default, reuseIdentifier: event_cell_identifier)
                }
                if let event = self.event(indexPath)
                {
                        cell!.update(event)
                }
                return cell!
        }
        
        func event(path: NSIndexPath) -> rmw_event?
        {
                if path.section == 0
                {
                        return rmw_user.shared_instance.created_events[path.row]
                }
                else if path.section == 1
                {
                        return rmw_user.shared_instance.upcoming_events[path.row]
                }
                else
                {
                        return rmw_user.shared_instance.recent_events[path.row]
                }
        }
        
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        {
                if let event = self.event(indexPath)
                {
                        self.event_delegate.expand_event(event)
                }
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
class events_table_view: rmw_table_view, UITableViewDataSource
{
        var events = rmw_ordered_map<Int,rmw_event>()
        unowned(unsafe) let event_delegate: rmw_event_delegate
        init(frame: CGRect, with_search_bar: Bool, event_delegate: rmw_event_delegate)
        {
                self.event_delegate = event_delegate
                super.init(frame: frame, with_search_bar: with_search_bar)
                self.registerClass(event_cell.classForCoder(), forCellReuseIdentifier: event_cell_identifier)
                self.dataSource = self
                if self.search_bar != nil
                {
                        
                        self.search_bar!.backgroundColor = UIColor.clearColor()
                }
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
                return searching ? search_match_ids!.count : max(1,events.count)
        }
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int
        {
                return 1
        }
        
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        {
                if events.count == 0
                {
                        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
                }
                var cell = self.dequeueReusableCellWithIdentifier(event_cell_identifier, forIndexPath: indexPath) as? event_cell
                if (cell == nil)
                {
                        cell = event_cell(style: .Default, reuseIdentifier: event_cell_identifier)
                }
                let event = searching ? self.events[search_match_ids![indexPath.row]]! : self.events.value_at_index(indexPath.row)!
                cell!.update(event)
                return cell!
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        {
                let event = searching ? self.events[search_match_ids![indexPath.row]]! : self.events.value_at_index(indexPath.row)!
                self.event_delegate.expand_event(event)
        }
        
        override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
        {
                return events_cell_height
        }
        
        override func search(string: String)
        {
                if self.events.count == 0
                {
                        return
                }
                if string.length() > 0
                {
                        search_match_ids!.removeAll(keepCapacity: true)
                        for event in self.events.values
                        {
                                if event.1.name.contains(string)
                                {
                                        search_match_ids!.append(event.1.id)
                                        continue
                                }
                                if event.1.description.contains(string)
                                {
                                        search_match_ids!.append(event.1.id)
                                        continue
                                }
                        }
                        
                        searching = true
                }
                else
                {
                        searching = false
                }
                self.reloadData()
        }

}

class rmw_event_ratio_view: UIView
{
        var joined_label: rmw_label!
        var volunteer_border: UIView!
        var wanted_label: rmw_label!
        
        override init(frame: CGRect)
        {
                super.init(frame: frame)
                joined_label = rmw_label(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2))
                joined_label.textColor = UIColor.soft_blue()
                joined_label.textAlignment = .Center
                joined_label.numberOfLines = 1
                joined_label.clipsToBounds = false
                self.addSubview(joined_label)
                
                wanted_label = rmw_label(frame: CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2))
                wanted_label.textColor = UIColor.soft_blue()
                wanted_label.textAlignment = .Center
                wanted_label.numberOfLines = 1
                wanted_label.clipsToBounds = false
                self.addSubview(wanted_label)
                
                volunteer_border = UIView(frame: CGRectMake(0, (self.frame.size.height + 1)/2, self.frame.size.width, 1))
                volunteer_border.backgroundColor = UIColor.concrete()
                self.addSubview(volunteer_border)
        }
        
        func update(joined: Int, quota: Int)
        {
                let joined_string = String(joined) + " joined"
                joined_label.text = joined_string
                wanted_label.text = String(quota) + " wanted"
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}

class event_cell: UITableViewCell
{
        //MARK: Member Variables
        
        var preview_view: event_preview_view!
        
        //MARK: Initializers
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?)
        {
                super.init(style: .Default, reuseIdentifier: reuseIdentifier)
                self.contentView.backgroundColor = UIColor.clearColor()
                self.backgroundColor = UIColor.clearColor()
                self.selectionStyle = .None
                
                preview_view = event_preview_view(frame: CGRect.zero(screen_size().width, events_cell_height))
                self.contentView.addSubview(preview_view)
        }
        
        required init?(coder aDecoder: NSCoder)
        {
                super.init(coder: aDecoder)
        }
        
        //MARK: Member Functions
        
        func update(event: rmw_event)
        {
                preview_view.update(event)
        }
        
        //MARK: Delegate Methods
}

class rmw_event
{
        var id: Int!
        var name: String!
        var creator_id: Int!
        var start_date: String!
        var time: String?
        var current_volunteer_count: Int = 0
        var wanted_volunteer_count: Int = 0
        var description: String = ""
        var street_address: String = ""
        var state: String = ""
        var zip: String = ""
        var organization: String = ""
        var image_url: String = ""
        
        init?(raw: Dictionary<String, AnyObject>)
        {
                if let raw_id = raw["id"] as? String
                {
                        self.id = raw_id.int_value
                }
                else if let raw_id = raw["id"] as? Int
                {
                        self.id = raw_id
                }
                else
                {
                        return nil
                }
                if let raw_name = raw["name"] as? String
                {
                        self.name = raw_name
                }
                else
                {
                        return nil
                }
                if let raw_creator_id = raw["creator_id"] as? String
                {
                        self.creator_id = raw_creator_id.int_value
                }
                else if let raw_creator_id = raw["creator_id"] as? Int
                {
                        self.creator_id = raw_creator_id
                }
                else
                {
                        return nil
                }
                if let raw_start_date = raw["start_date"] as? String
                {
                        self.start_date = raw_start_date
                }
                if let raw_organization = raw["organization"] as? String
                {
                        self.organization = raw_organization
                }
                if let raw_current_number_volunteers = raw["current_num_volunteers"] as? String
                {
                        self.current_volunteer_count = raw_current_number_volunteers.int_value
                }
                else if let raw_current_number_volunteers = raw["current_num_volunteers"] as? Int
                {
                        self.current_volunteer_count = raw_current_number_volunteers
                }
                if let raw_max_number_volunteers = raw["max_volunteers_needed"] as? String
                {
                        self.wanted_volunteer_count = raw_max_number_volunteers.int_value
                }
                else if let raw_max_number_volunteers = raw["max_volunteers_needed"] as? Int
                {
                        self.wanted_volunteer_count = raw_max_number_volunteers
                }
                if let raw_description = raw["description"] as? String
                {
                        self.description = raw_description
                }
                if let raw_street_address = raw["street_addr"] as? String
                {
                        self.street_address = raw_street_address
                }
                if let raw_state = raw["state"] as? String
                {
                        self.state = raw_state
                }
                if let raw_zipcode = raw["zipcode"] as? String
                {
                        self.zip = raw_zipcode
                }
        }
}