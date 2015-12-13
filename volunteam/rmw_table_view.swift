//
//  rmw_table_view.swift
//  volunteam
//
//  Created by Ryan Wolande on 11/11/15.
//  Copyright © 2015 Ryan Wolande. All rights reserved.
//

import Foundation

//  rmw_table_view.swift

import UIKit

//empty_cell.swift

import UIKit

//rmw_label.swift

import UIKit
import QuartzCore

let default_kerning: CGFloat = 0.3
class rmw_label: UILabel
{
        //MARK: Member Variables
        
        var kerning = default_kerning
                {
                didSet
                {
                        if self.text != nil
                        {
                                let txt = self.text!
                                self.text = txt
                        }
                }
        }
        
        //MARK: Initializers
        
        private var initial_size = CGSizeZero
        override var text: String?
                {
                didSet
                {
                        if text == nil
                        {
                                return
                        }
                        let attributed_string = NSMutableAttributedString(string: text!)
                        attributed_string.addAttribute(NSKernAttributeName, value: kerning, range: NSMakeRange(0, text!.length()))
                        self.attributedText = attributed_string
                }
        }
        
        internal override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
        {
                if !self.userInteractionEnabled
                {
                        return nil
                }
                let buttonSize = self.frame.size
                let widthToAdd = (44-buttonSize.width > 0) ? 44-buttonSize.width : 0
                let heightToAdd = (44-buttonSize.height > 0) ? 44-buttonSize.height : 0
                let largerFrame = CGRect(x: 0-(widthToAdd/2), y: 0-(heightToAdd/2), width: buttonSize.width+widthToAdd, height: buttonSize.height+heightToAdd)
                return (CGRectContainsPoint(largerFrame, point)) ? self : nil
        }
        
        init()
        {
                super.init(frame: CGRectZero)
                self.standardize()
        }
        
        init(_ font: UIFont)
        {
                super.init(frame: CGRectZero)
                self.standardize()
                self.font = font
        }
        
        func standardize()
        {
                self.initial_size = frame.size
                //self.font = UIFont.regular(10)
                self.numberOfLines = 0
                self.textColor = .medium_gray()
                self.layer.masksToBounds = false
                self.clipsToBounds = false
                self.lineBreakMode = NSLineBreakMode.ByWordWrapping
        }
        
        override init(frame: CGRect)
        {
                super.init(frame: frame)
                self.standardize()
        }
        
        required init?(coder aDecoder: NSCoder)
        {
                super.init(coder: aDecoder)
        }
        
        init(string: String, font: UIFont, center: CGPoint)
        {
                let frame = CGRect.zero(screen_size().width, screen_size().height)
                super.init(frame: frame)
                self.standardize()
                self.text = string
                self.font = font
                //self.trim_width(true)
                //self.trim_height(true)
                self.center = center
        }
        
        init(string: String, font: UIFont)
        {
                super.init(frame: CGRectZero)
                self.standardize()
                self.text = string
                self.font = font
        }
        
        init(string: String, font: UIFont, frame: CGRect)
        {
                super.init(frame: frame)
                self.standardize()
                self.text = string
                self.font = font
        }
        
        //MARK: Member Functions
        
        /*func trim_height(preserve_center: Bool) -> CGFloat
        {
                if frame.size.width < 1
                {
                        print("less than 1")
                        self.frame.size.width = initial_size.width
                }
                if self.text != nil
                {
                        let center = self.center.y
                        print("height pre: \(self.frame.size.height)")
                        self.frame.size.height = self.font.height(self.text!, self.frame.size.width, kerning: kerning)
                        print("height post: \(self.frame.size.height)")
                        if preserve_center
                        {
                                self.center.y = center
                        }
                        return self.frame.size.height
                }
                return 0
        }
        
        func trim_width(preserve_center: Bool) -> CGFloat
        {
                if frame.size.height < 1
                {
                        self.frame.size.height = initial_size.height
                }
                if self.text != nil
                {
                        let center = self.center.x
                        let new_width = self.font.width(self.text!, self.frame.size.height, kerning: kerning)
                        self.frame.size.width = new_width
                        if preserve_center
                        {
                                self.center.x = center
                        }
                        return new_width
                }
                return 0
        }*/
        
        func fit(max_width: CGFloat)
        {
                let max_size = CGSizeMake(max_width, CGFloat(HUGE))
                let expected_size = self.sizeThatFits(max_size)
                self.frame.size = expected_size
        }
        
        func trim(preserve_center: Bool)
        {
                //self.trim_width(preserve_center)
                //self.trim_height(preserve_center)
        }
        
        //MARK: Delegate Methods
        
}

func screen_size() -> CGSize
{
        return UIScreen.mainScreen().bounds.size
}

func screen_frame() -> CGRect
{
        return UIScreen.mainScreen().bounds
}

func status_bar_height() -> CGFloat
{
        let status_bar_size = UIApplication.sharedApplication().statusBarFrame.size
        return min(status_bar_size.width, status_bar_size.height)
}

class empty_cell: UITableViewCell
{
        //MARK: Member Variables
        
        var title_label: rmw_label!
        var message_label: rmw_label!
        
        //MARK: Initializers
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?)
        {
                super.init(style: .Default, reuseIdentifier: reuseIdentifier)
                self.contentView.backgroundColor = UIColor.clearColor()
                self.backgroundColor = UIColor.clearColor()
                self.selectionStyle = .None
                
                title_label = rmw_label()
                title_label.frame = CGRectMake(padding * 2, padding, screen_size().width-padding*4, screen_size().width/6)
                title_label.textAlignment = .Center
                title_label.textColor = .dark_gray()
                self.contentView.addSubview(title_label)
                
                message_label = rmw_label()
                message_label.frame = CGRectMake(self.title_label.frame.origin.x, self.title_label.frame.y_end+post_padding, self.title_label.frame.size.width, title_label.frame.size.height)
                message_label.textAlignment = .Center
                self.contentView.addSubview(message_label)
        }
        
        required init?(coder aDecoder: NSCoder)
        {
                super.init(coder: aDecoder)
        }
        
        //MARK: Member Functions
        
        func update(title: String, message: String, width: CGFloat)
        {
                title_label.text = title
                message_label.text = message
                //title_label.trim_height(false)
                title_label.frame.origin.y = padding
                //message_label.trim_height(false)
                message_label.frame.origin.y = title_label.frame.y_end + post_padding
        }
        
        //MARK: Delegate Methods
}

class rmw_table_view: UITableView, UITableViewDelegate, rmw_search_protocol
{
        var search_bar: rmw_search_bar?
        var searching: Bool = false
        var search_match_ids: [Int]?
        
        var prior_offset: CGFloat = 0.0
       //weak var navigation_setter: navigation_view_setter?
       // weak var visual_setter: canvas_visual_view_setter?
        
        var empty_title: String = "Nothing here"
        var empty_message: String = "Make an Event to get the ball rolling"
        
        init(frame: CGRect, with_search_bar: Bool = false)
        {
                super.init(frame: frame, style: .Plain)
                self.backgroundColor = .clearColor()
                self.separatorStyle = UITableViewCellSeparatorStyle.None
                self.delegate = self
                
                if with_search_bar
                {
                        search_bar = rmw_search_bar(width: self.frame.size.width, delegate: self)
                        self.search_match_ids = [Int]()
                        self.tableHeaderView = search_bar
                        self.contentOffset.y = search_bar!.frame.size.height
                }
                self.registerClass(empty_cell.classForCoder(), forCellReuseIdentifier: empty_cell_identifier)
        }
        
        required init?(coder aDecoder: NSCoder)
        {
                super.init(coder: aDecoder)
        }
        
        func scrollViewDidScroll(scrollView: UIScrollView)
        {
                if scrollView.contentSize.height < screen_size().height * 1.5
                {
                        return
                }
                /*let y_ratio = scrollView.y_ratio()
                if y_ratio > 1
                {
                        return
                }
                visual_setter?.scroll_view_did_scroll(self)
                let new_offset = scrollView.contentOffset.y
                var difference = prior_offset - new_offset
                if search_bar != nil && self.contentOffset.y < self.search_bar!.frame.size.height && new_offset > 0
                {
                        return
                }
                if navigation_setter == nil
                {
                        
                }
                if let _ = navigation_setter?.shift_bars(self, views_to_shift_origin: [self], views_to_shift_height: [self], amount: &difference)
                {
                        
                }
                prior_offset = scrollView.contentOffset.y*/
        }
        
        func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
        {
                if !decelerate
                {
                        self.scroll_released_while_stopped()
                }
        }
        
        func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
        {
                if velocity.y != 0
                {
                        self.scroll_released_while_scrolling(targetContentOffset.memory.y)
                }
        }
        
        func scroll_released_while_stopped()
        {
                //self.visual_setter?.scroll_released_while_stopped(self)
                //self.navigation_setter?.scroll_released_while_stopped(self, views_to_shift_origin: [self], views_to_shift_height: [self])
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        {
                var cell = self.dequeueReusableCellWithIdentifier(empty_cell_identifier, forIndexPath: indexPath) as? empty_cell
                if (cell == nil)
                {
                        cell = empty_cell(style: .Default, reuseIdentifier: empty_cell_identifier)
                }
                cell!.update(empty_title, message: empty_message, width: self.frame.size.width)
                return cell!
        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
        {
                return empty_cell_height
        }
        
        func scroll_released_while_scrolling(destination_y: CGFloat)
        {
                //self.visual_setter?.scroll_released_while_scrolling(self)
                //self.navigation_setter?.scroll_released_while_scrolling(self, views_to_shift_origin: [self], views_to_shift_height: [self], new_offset_y: destination_y)
        }
        
        func search(string: String)
        {}
        
        func cleared_search()
        {
                searching = false
                self.reloadData()
        }
        
        func filter(index_paths: [NSIndexPath], insert: Bool)
        {
                if insert
                {
                        self.insertRowsAtIndexPaths(index_paths, withRowAnimation: UITableViewRowAnimation.Left)
                }
                else
                {
                        self.deleteRowsAtIndexPaths(index_paths, withRowAnimation: UITableViewRowAnimation.Right)
                }
        }
        
        /*func padding_cell(indexPath: NSIndexPath) -> rmw_settings_padding_cell
        {
                var cell = self.dequeueReusableCellWithIdentifier(rmw_settings_padding_cell_identifier, forIndexPath: indexPath) as? rmw_settings_padding_cell
                if (cell == nil)
                {
                        cell = rmw_settings_padding_cell(style: .Default, reuseIdentifier: rmw_settings_padding_cell_identifier)
                }
                cell!.contentView.backgroundColor = .light_gray()
                return cell!
        }*/
}

extension CGRect
{
        static func zero(length: CGFloat) -> CGRect
        {
                return CGRect(x: 0, y: 0, width: length, height: length)
        }
        
        static func zero(width: CGFloat, _ height: CGFloat) -> CGRect
        {
                return CGRect(x: 0, y: 0, width: width, height: height)
        }
        
        static func zero(size: CGSize) -> CGRect
        {
                return CGRect(origin: CGPointZero, size: size)
        }
        
        static func screen() -> CGRect
        {
                return CGRect(origin: CGPointZero, size: CGSize.screen())
        }
        
        var x_end: CGFloat!
                {
                        return self.origin.x + self.size.width
        }
        
        var y_end: CGFloat!
                {
                        return self.origin.y + self.size.height
        }
        
        var end: CGPoint
                {
                        return CGPointMake(self.origin.x + self.size.width, self.origin.y + self.size.height)
        }
        
        var midpoint: CGPoint
                {
                        return CGPointMake(self.size.width / 2, self.size.height / 2)
        }
}

extension CGSize
{
        static func screen() -> CGSize
        {
                return UIScreen.mainScreen().bounds.size
        }
        
        init(_ side: CGFloat)
        {
                self.height = side
                self.width = side
        }
}