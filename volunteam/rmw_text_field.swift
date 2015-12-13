//rmw_text_field.swift

import UIKit

@objc protocol text_delegate: class
{
        optional func began_editing(tag: Int)
        optional func text_changed(text: String, _ tag: Int)
        optional func next()
        optional func finished(text_field: rmw_text_field)
}

let small_label_font: UIFont = UIFont.systemFontOfSize(11)
class rmw_pop_up_text_field: UIView, text_delegate
{
        var field: rmw_text_field!
        private var pop_up_string: String!
        private var pop_up_label: rmw_label!
        private var second_pop_up_label: rmw_label?
        private var pop_up_is_visible: Bool = false
        var underline: UIView!
        
        weak var text_protocol: text_delegate?
        
        init(frame: CGRect, pop_up_string: String)
        {
                super.init(frame: frame)
                field = rmw_text_field(frame: CGRectMake(0, self.frame.size.height/4, self.frame.size.width, self.frame.size.height/golden_ratio))
                field.insets = false
                //field.font = pop_up_field_font
                field.text_protocol = self
                field.textColor = UIColor.tony_gray()
                self.addSubview(field)
                
                pop_up_label = rmw_label(string: pop_up_string, font: small_label_font, frame: CGRectMake(0, self.frame.size.height/4, self.frame.size.width, 12))
                pop_up_label.alpha = 0
                //pop_up_label!.trim_height(false)
                //pop_up_label!.trim_width(false)
                pop_up_label!.frame.origin.y = self.frame.size.height / 4
                self.addSubview(self.pop_up_label)
                
                underline = UIView(frame: CGRectMake(0, self.frame.size.height - border_thin_length, self.frame.size.width, border_thin_length))
                underline.backgroundColor = UIColor.border_gray()
                self.addSubview(underline)
        }
        
        func update_pop_up(string: String)
        {
                self.pop_up_string = string
                self.pop_up_label.text = string
                //pop_up_label.trim_width(false)
                if second_pop_up_label != nil && second_pop_up_label!.text != nil
                {
                        self.set_second_string(second_pop_up_label!.text!)
                }
        }
        
        func set_second_string(second: String)
        {
                //pop_up_label.trim_width(false)
                if second_pop_up_label == nil
                {
                        second_pop_up_label = rmw_label(string: second, font: pop_up_label.font, frame: CGRectMake(pop_up_label.frame.x_end + post_padding, self.frame.size.height/4, self.frame.size.width - (pop_up_label.frame.x_end + post_padding), 12))
                        self.addSubview(second_pop_up_label!)
                }
                
                //second_pop_up_label?.trim_height(false)
                //second_pop_up_label?.trim_width(false)
                second_pop_up_label?.alpha = pop_up_label.alpha
                second_pop_up_label?.frame.origin.y = pop_up_label.frame.origin.y
        }
        
        func set_color(first: Bool = true, color: UIColor = UIColor.green())
        {
                if first
                {
                        pop_up_label.textColor = color
                }
                else
                {
                        second_pop_up_label?.textColor = color
                }
        }
        
        func unset_color(first: Bool = true)
        {
                if first
                {
                        pop_up_label.textColor = UIColor.medium_gray()
                }
                else
                {
                        second_pop_up_label?.textColor = UIColor.medium_gray()
                }
        }
        
        func show_pop_up()
        {
                self.animate_spring(
                        {
                                self.pop_up_label!.frame.origin.y = 0
                                self.pop_up_label!.alpha = 1
                                self.second_pop_up_label?.alpha = self.pop_up_label.alpha
                                self.second_pop_up_label?.frame.origin.y = self.pop_up_label.frame.origin.y
                        }, completion:
                        {
                                finished in
                                self.pop_up_is_visible = true
                })
        }
        
        private func hide_pop_up()
        {
                self.animate_spring(
                        {
                                self.pop_up_label!.frame.origin.y = self.frame.size.height / 4
                                self.pop_up_label!.alpha = 0
                                self.second_pop_up_label?.alpha = self.pop_up_label.alpha
                                self.second_pop_up_label?.frame.origin.y = self.pop_up_label.frame.origin.y
                        }, completion:
                        {
                                finished in
                                self.pop_up_is_visible = false
                })
        }
        
        
        func began_editing(tag: Int)
        {
                self.text_protocol?.began_editing?(tag)
        }
        func text_changed(text: String, _ tag: Int)
        {
                let new_length = text.length()
                if pop_up_is_visible && new_length == 0
                {
                        self.hide_pop_up()
                }
                else if !pop_up_is_visible && new_length > 0
                {
                        self.show_pop_up()
                }
                self.text_protocol?.text_changed?(text, tag)
        }
        func next()
        {
                self.text_protocol?.next?()
        }
        func finished(text_field: rmw_text_field)
        {
                self.text_protocol?.finished?(text_field)
        }
        
        required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}

let default_field_font = UIFont.systemFontOfSize(13)
class rmw_text_field: UITextField, UITextFieldDelegate
{
        //MARK: Member Variables
        
        var character_limit: Int = 30
        weak var text_protocol: text_delegate?
        var should_resign: Bool = true
        var allows_handle: Bool = true
        var allows_space: Bool = true
        
        var accessory: UIView!
        
        var insets: Bool = true
        
        //MARK: Initializers
        
        init()
        {
                super.init(frame: CGRectZero)
                self.font = default_field_font
                self.delegate = self
                self.textColor = .dark_gray()
                self.addTarget(self, action: "text_changed", forControlEvents: UIControlEvents.EditingChanged)
                self.keyboardAppearance = UIKeyboardAppearance.Default
                
                self.accessory = UIView(frame: CGRectZero)
                
                self.tintColor = UIColor.green()
        }
        
        override init(frame: CGRect)
        {
                super.init(frame: frame)
                self.font = default_field_font
                self.delegate = self
                self.textColor = .dark_gray()
                self.addTarget(self, action: "text_changed", forControlEvents: UIControlEvents.EditingChanged)
                self.keyboardAppearance = UIKeyboardAppearance.Default
                self.accessory = UIView(frame: CGRectZero)
                
                
                self.tintColor = UIColor.green()
        }
        
        required init?(coder aDecoder: NSCoder)
        {
                super.init(coder: aDecoder)
        }
        
        var optional_for_query: String
                {
                        if self.text != nil && self.text!.length() > 0
                        {
                                return self.text!
                        }
                        if self.attributedText != nil && self.attributedText!.length > 0
                        {
                                return self.attributedText!.string
                        }
                        if self.placeholder != nil && self.placeholder!.length() > 0
                        {
                                return self.placeholder!
                        }
                        return ""
        }
        
        /*func keyboardWillShow(notification: NSNotification)
        {
        if self.accessory.superview != nil
        {
        self.accessory.superview!.hidden = false
        }
        self.keyboard_delegate?.keyboard_will_show?(notification)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "keyboardWillShow:", object: nil)
        }
        
        func keyboardDidShow()
        {
        if self.accessory.superview != nil
        {
        if self.keyboard_delegate != nil
        {
        self.keyboard_delegate?.keyboard_did_show?()
        }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "keyboardDidShow", object: nil)
        }
        
        func keyboardWillHide(notification: NSNotification)
        {
        self.keyboard_delegate?.keyboard_will_hide?(notification)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "keyboardWillHide:", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow", name: UIKeyboardDidShowNotification, object: nil)
        }*/
        
        func set_placeholder(text: String, color: UIColor = .medium_gray())
        {
                let string = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName:color])
                self.attributedPlaceholder = string
        }
        
        //MARK: Member Functions
        
        func text_changed()
        {
                self.text_protocol?.text_changed?(self.text!, self.tag)
        }
        
        //MARK: Delegate Methods
        
        func textFieldShouldBeginEditing(textField: UITextField) -> Bool
        {
                self.text_protocol?.began_editing?(self.tag)
                return true
        }
        
        func textFieldShouldReturn(textField: UITextField) -> Bool
        {
                if self.should_resign
                {
                        self.resignFirstResponder()
                        self.text_protocol?.finished?(self)
                        return true
                }
                else
                {
                        self.text_protocol?.next?()
                        return false
                }
        }
        
        func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
        {
                let new_length = (string.length() - range.length) + textField.text!.length()
                if !allows_handle && new_length > 0 && string.length() > 0
                {
                        let char = string.characters.first
                        if char == "@"
                        {
                                return false
                        }
                        
                }
                if !allows_space && new_length > 0 && string.length() > 0
                {
                        let char = string.characters.first
                        if char == " "
                        {
                                return false
                        }
                }
                return !(new_length > character_limit)
        }
        
        override func textRectForBounds(bounds: CGRect) -> CGRect
        {
                return CGRectMake(bounds.origin.x + (insets ? padding : 0), bounds.origin.y, bounds.size.width - (insets ? padding*2 : 0), bounds.size.height)
        }
        
        override func editingRectForBounds(bounds: CGRect) -> CGRect
        {
                return CGRectMake(bounds.origin.x + (insets ? padding : 0), bounds.origin.y, bounds.size.width - (insets ? padding*2 : 0), bounds.size.height)
        }
}

extension String
{
        var md5: String!
                {
                        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
                        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
                        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
                        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
                        
                        CC_MD5(str!, strLen, result)
                        
                        let hash = NSMutableString()
                        for i in 0..<digestLen {
                                hash.appendFormat("%02x", result[i])
                        }
                        
                        result.destroy()
                        
                        return String(format: hash as String)
        }
        
        
        func stringByAppendingPathComponent(path: String) -> String{
                
                let ns_string = self as NSString
                
                return ns_string.stringByAppendingPathComponent(path)
        }
        
        func length() -> Int
        {
                return self.utf16.count //count(self.utf16)//self.utf16.count
        }
        
        func contains(find: String) -> Bool
        {
                return self.lowercaseString.rangeOfString(find.lowercaseString) != nil
        }
        
        var float_value: Float
                {
                        return (self as NSString).floatValue
        }
        
        var double_value: Double
                {
                        return (self as NSString).doubleValue
        }
        
        var bool_value: Bool
                {
                        return self.int_value == 1
        }
        
        var int_value: Int
                {
                        if let int = Int(self)
                        {
                                return int
                        }
                        return 0
        }
        
        /*func height(font: UIFont, width: CGFloat) -> CGFloat
        {
                return font.height(self, width)
        }*/
        
        func media_key() -> Bool
        {
                return self.length() > 3
        }
}

extension Int
{
        var is_users_id: Bool
                {
                        return true
        }
}