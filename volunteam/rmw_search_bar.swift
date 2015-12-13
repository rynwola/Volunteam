//rmw_search_bar.swift

import UIKit

protocol rmw_search_protocol: class
{
        func search(string: String)
        func cleared_search()
}

let post_padding: CGFloat = 4
let border_thin_length: CGFloat = 1
let search_bar_height: CGFloat = 40

class rmw_search_bar: UIView, text_delegate
{
        var search_field: rmw_text_field!
        var cancel_button: UIButton!
        unowned(unsafe) let delegate: rmw_search_protocol
        
        init(width: CGFloat, delegate: rmw_search_protocol)
        {
                self.delegate = delegate
                super.init(frame: CGRect.zero(width, search_bar_height))
                self.backgroundColor = .light_gray()
                search_field = rmw_text_field(frame: CGRectMake(post_padding, post_padding, self.frame.size.width - post_padding*2, self.frame.size.height - post_padding*2))
                search_field.backgroundColor = .whiteColor()
                search_field.layer.cornerRadius = post_padding
                search_field.clipsToBounds = true
                search_field.layer.borderWidth = border_thin_length
                search_field.layer.borderColor = UIColor.border_gray().CGColor
                search_field.placeholder = "search"
                search_field.text_protocol = self
                search_field.textAlignment = .Center
                self.addSubview(search_field)
                
                cancel_button = UIButton(frame: CGRectMake(self.frame.size.width,post_padding,self.frame.size.width/5 - post_padding * 3,self.frame.size.height-post_padding*2))
                cancel_button.setTitle("cancel", forState: UIControlState.Normal)
                cancel_button.addTarget(self, action: "finished", forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(cancel_button)
                
                //self.add_borders([.Top,.Bottom], thickness: border_thin_length, color: .border_gray())
        }
        
        required init?(coder aDecoder: NSCoder)
        {
                fatalError("init(coder:) has not been implemented")
        }
        
        func began_editing(tag: Int)
        {
                cancel_button.enabled = true
                /*UIView.animateWithDuration(animation_duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations:
                        {
                                self.search_field.textAlignment = .Left
                                self.search_field.frame.size.width = self.frame.size.width * 4/5
                                self.cancel_button.frame.origin.x = self.search_field.frame.x_end + post_padding
                        }, completion: nil)*/
        }
        
        func text_changed(text: String, _ tag: Int)
        {
                self.delegate.search(text)
        }
        
        func finished()
        {
                cancel_button.enabled = false
                self.search_field.text = ""
                self.search_field.textAlignment = .Center
                delegate.cleared_search()
                self.search_field.resignFirstResponder()
                /*UIView.animateWithDuration(animation_duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations:
                        {
                                self.search_field.frame.size.width = self.frame.size.width - post_padding * 2
                                self.cancel_button.frame.origin.x = self.search_field.frame.x_end + post_padding
                        }, completion:
                        {
                                finished in
                                //self.search_field.resignFirstResponder()
                                return
                })*/
        }
        
        func finished(text_field: rmw_text_field)
        {
                self.finished()
        }
}