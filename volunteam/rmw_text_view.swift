
//rmw_text_view.swift

import UIKit

class rmw_text_view: UITextView, UITextViewDelegate
{
        //MARK: Member Variables
        
        var new_lines: Int = 0
        var new_line_limit: Int = 6
        var new_lines_enabled = false
        var accessory: UIView!
        //var keyboard_delegate: keyboard_protocol?
        var character_limit = 240
        
        weak var text_protocol: text_delegate?
        
        var is_showing = false
        
        var placeholder_label: rmw_label?
        
        override var text: String!
                {
                didSet
                {
                        if text == nil
                        {
                                return
                        }
                        let attributed_string = NSMutableAttributedString(string: text!)
                        attributed_string.addAttribute(NSKernAttributeName, value: default_kerning, range: NSMakeRange(0, text!.length()))
                        self.attributedText = attributed_string
                }
        }
        
        //MARK: Initializers
        
        init()
        {
                super.init(frame: CGRectZero, textContainer: nil)
                self.set()
        }
        
        init(frame: CGRect)
        {
                super.init(frame: frame, textContainer: nil)
                self.set()
        }
        
        required init?(coder aDecoder: NSCoder)
        {
                super.init(coder: aDecoder)
        }
        
        /*func keyboard_is_hidden() -> Bool
        {
        if self.accessory.superview == nil || self.accessory.superview!.hidden
        {
        return true
        }
        return false
        }*/
        
        func set()
        {
                self.delegate = self
                self.backgroundColor = .whiteColor()
                //self.font = .light(24)
                self.textColor = .medium_gray()
                self.accessory = UIView(frame: CGRectZero)
                self.inputAccessoryView = self.accessory
                self.keyboardAppearance = UIKeyboardAppearance.Dark
                //self.add_show_observers()
        }
        
        func set_placeholder(placeholder: String, text_color: UIColor = .medium_gray(), top_left: Bool = false)
        {
                if placeholder_label == nil
                {
                        placeholder_label = rmw_label(string: placeholder, font: self.font!, center: self.frame.midpoint)
                        self.addSubview(placeholder_label!)
                }
                if top_left
                {
                        placeholder_label!.frame.origin.x = 10
                        placeholder_label!.frame.origin.y = 10
                }
                
                placeholder_label!.textColor = text_color
        }
        
        func remove_all_observers()
        {
                //self.remove_hide_observers()
                //self.remove_show_observers()
        }
        
        func update_height(min: CGFloat, max: CGFloat = screen_size().width / 2)
        {
                var new_height:CGFloat = self.sizeThatFits(CGSize(width: self.frame.size.width, height: CGFloat.max)).height
                //self.frame.size.height = bound(&new_height, minimum: min, maximum: max)
        }
        
        //MARK: Member Functions
        
        //MARK: Delegate Methods
        
        func textViewShouldBeginEditing(textView: UITextView) -> Bool
        {
                self.text_protocol?.text_changed?(self.text, self.tag)
                if placeholder_label != nil
                {
                        placeholder_label!.hidden = true
                }
                return true
        }
        
        func textViewDidChange(textView: UITextView)
        {
                if placeholder_label != nil
                {
                        placeholder_label!.hidden = self.text.length() > 0
                }
                self.text_protocol?.text_changed?(self.text, self.tag)
        }
        
        func textViewShouldEndEditing(textView: UITextView) -> Bool
        {
                if placeholder_label != nil
                {
                        placeholder_label!.hidden = self.text.length() > 0
                }
                return true
        }
        
        func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
        {
                if self.text.length() == 0
                {
                        return true
                }
                if text == "\n"
                {
                        if new_lines_enabled
                        {
                                if new_line_limit == new_lines
                                {
                                        return false
                                }
                                else
                                {
                                        ++new_lines
                                        return true
                                }
                        }
                        else
                        {
                                textView.resignFirstResponder()
                                return false
                        }
                }
                let count = (textView.text.length() - range.length) + text.length()
                if count < character_limit
                {
                        return true
                }
                else
                {
                        return false
                }
        }
        
        func update_text_count()
        {
                new_lines = self.text.componentsSeparatedByString("\n").count-1
                self.text_protocol?.text_changed?(self.text, self.tag)
        }
}