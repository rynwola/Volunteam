import UIKit

class rmw_user
{
        static var shared_instance = rmw_user()
        var id: Int!
        var first_name: String = "John"
        var last_name: String = "Doe"
        var image_url: String?
        var events = [rmw_event]()
        var hours_goal: Int = 0
        var hours_achieved: Int = 0
        var signed_in: Bool
        {
                return self.id != nil && self.id != 0
        }
        var percent: CGFloat
                {
                        return hours_goal == 0 ? 0 : CGFloat(hours_achieved) / CGFloat(hours_goal)
        }
        
        init()
        {
                self.id = 0
        }
        
        init?(raw: Dictionary<String,AnyObject>)
        {
                if let id = raw["id"] as? Int
                {
                        self.id = id
                }
                else
                {
                        return nil
                }
                if let first_name = raw["first_name"] as? String
                {
                        self.first_name = first_name
                }
                if let last_name = raw["last_name"] as? String
                {
                        self.last_name = last_name
                }
                NSUserDefaults.standardUserDefaults().setObject(raw, forKey: "user_info")
        }
        
        func reset()
        {
                self.id = 0
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "user_info")
        }

}

let flat_height: CGFloat = 40
class me_view_controller: UIViewController, query_delegate, rmw_event_delegate
{
        var image_view: UIImageView!
        var name_label: rmw_label!
        var goal_view: rmw_goal_view!
        var progress_label: rmw_label!
        var table_view: events_table_view!
        var sign_out_button: UIButton!
        
        override func viewDidLoad()
        {
                super.viewDidLoad()
                self.view.backgroundColor = UIColor.light_gray()
                
                image_view = UIImageView(frame: CGRectMake(padding, padding + status_bar_height(), 100, 100))
                image_view.backgroundColor = UIColor.medium_gray()
                image_view.image = UIImage(named: "space")
                image_view.contentMode = UIViewContentMode.ScaleAspectFill
                image_view.layer.cornerRadius = 4
                image_view.clipsToBounds = true
                self.view.addSubview(image_view)
                
                name_label = rmw_label(frame: CGRectMake(image_view.frame.x_end + padding, image_view.frame.origin.y, 100, 100))
                name_label.text = rmw_user.shared_instance.first_name + " " + rmw_user.shared_instance.last_name
                name_label.textColor = UIColor.dark_gray()
                name_label.font = UIFont.systemFontOfSize(18)
                self.view.addSubview(name_label)
                
                goal_view = rmw_goal_view(frame: CGRectMake(padding, image_view.frame.y_end + padding, self.view.frame.size.width - padding * 2, 40))
                goal_view.update(rmw_user.shared_instance.percent)
                self.view.addSubview(goal_view)
                
                progress_label = rmw_label(frame: CGRectMake(padding, padding, self.goal_view.frame.size.width - padding * 2, goal_view.frame.size.height - padding * 2))
                progress_label.textColor = UIColor.dark_gray()
                progress_label.text = String(rmw_user.shared_instance.hours_achieved) + " / " + String(rmw_user.shared_instance.hours_goal) + " hours"
                if rmw_user.shared_instance.percent > 0.5
                {
                        progress_label.textAlignment = .Right
                }
                else
                {
                        progress_label.textAlignment = .Left
                }
                self.goal_view.addSubview(progress_label)
                
                table_view = events_table_view(frame: CGRectMake(0, self.goal_view.frame.y_end + post_padding, self.view.frame.size.width, self.view.frame.size.height - (goal_view.frame.y_end + flat_height + self.tabBarController!.tabBar.frame.size.height + post_padding)), with_search_bar: true, event_delegate: self)
                table_view.backgroundColor = UIColor.whiteColor()
                self.view.addSubview(table_view)
                
                var border = UIView(frame: CGRectMake(table_view.frame.origin.x, table_view.frame.origin.y, self.view.frame.size.width, border_thin_length))
                border.backgroundColor = UIColor.border_gray()
                self.view.addSubview(border)
                
                let sign_out_top_border = UIView(frame: CGRect.zero(self.view.frame.size.width, border_thin_length))
                sign_out_top_border.backgroundColor = UIColor.transparent_black(0.5)
                sign_out_button = UIButton(frame: CGRectMake(0, table_view.frame.y_end, self.view.frame.size.width, flat_height))
                sign_out_button.backgroundColor = UIColor.alizarin()
                sign_out_button.setTitle("sign out", forState: UIControlState.Normal)
                sign_out_button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                sign_out_button.addTarget(self, action: "sign_out", forControlEvents: UIControlEvents.TouchUpInside)
                sign_out_button.addSubview(sign_out_top_border)
                self.view.addSubview(sign_out_button)

                
        }
        
        func sign_out()
        {
                run_on_background_thread(
                {
                        rmw_user.shared_instance.reset()
                        run_on_main_thread(
                                {
                                        (UIApplication.sharedApplication().delegate as! AppDelegate).assign_root_as_tab()
                        })
                })
                print("sign out")
        }
        
        func expand_event(event: rmw_event)
        {
                
        }
        
        func manage_response(response_query: query, _ response: Dictionary<String, AnyObject>)
        {
                
        }
        
        func failed_response(response_query: query)
        {
                
        }
}

class rmw_goal_view: UIView
{
        var inside_view: UIView!
        override init(frame: CGRect)
        {
                super.init(frame: frame)
                self.backgroundColor = UIColor.white_smoke()
                self.layer.cornerRadius = self.frame.size.height/2
                inside_view = UIView(frame: CGRect.zero(self.frame.size.width, self.frame.size.height))
                inside_view.backgroundColor = UIColor.soft_blue()
                self.addSubview(inside_view)
                self.clipsToBounds = true
                self.layer.borderColor = UIColor.border_gray().CGColor
                self.layer.borderWidth = 1
        }
        
        func update(percent: CGFloat)
        {
                inside_view.frame.size.width = self.frame.size.width * percent
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}

extension UIView
{
        
        func wobble(scale: CGFloat = 1.2)
        {
                let expand_transform:CGAffineTransform = CGAffineTransformMakeScale(scale, scale)
                self.transform = expand_transform
                UIView.animateWithDuration(0.4,
                        delay:0.0,
                        usingSpringWithDamping:0.3,
                        initialSpringVelocity:0.2,
                        options: .CurveEaseInOut,
                        animations: {
                                self.transform = CGAffineTransformIdentity//CGAffineTransformInvert(expandTransform)
                        }, completion:
                        {
                                //Code to run after animating
                                (value: Bool) in
                })
        }
        
        var golden_inset_x: CGFloat
                {
                        return (self.frame.size.width - self.golden_width) / 2
        }
        
        var golden_inset_y: CGFloat
                {
                        return (self.frame.size.height - self.golden_height) / 2
        }
        
        var golden_width: CGFloat
                {
                        return self.frame.size.width / golden_ratio
        }
        
        var golden_height: CGFloat
                {
                        return self.frame.size.height / golden_ratio
        }
        
        func golden_frame(centered: Bool = true) -> CGRect
        {
                if centered
                {
                        return CGRectMake(golden_inset_x, golden_inset_y, golden_width, golden_height)
                }
                return CGRectMake(0, 0, self.golden_width, self.golden_height)
        }
        
        func create_mask_center(center: CGPoint, radius: CGFloat) -> CAShapeLayer
        {
                let mask_layer = CAShapeLayer()
                
                // Create a path with the rectangle in it.
                let path = CGPathCreateMutable()
                
                CGPathAddArc(path, nil, center.x - radius/2, center.y - radius/2, radius, 0.0, 2 * CGFloat(M_PI), false)
                CGPathAddRect(path, nil, CGRect.zero(self.frame.size))
                
                mask_layer.backgroundColor = UIColor.blackColor().CGColor
                mask_layer.path = path
                mask_layer.fillRule = kCAFillRuleEvenOdd
                //mask_layer.anchorPoint = CGPointMake(0.5, 0.5)
                //mask_layer.bounds = self.bounds
                
                // Release the path since it's not covered by ARC.
                self.layer.mask = mask_layer
                self.clipsToBounds = true
                return mask_layer
        }
        
        func create_mask(frame : CGRect, radius: CGFloat) -> CAShapeLayer
        {
                let mask_layer = CAShapeLayer()
                
                // Create a path with the rectangle in it.
                let path = CGPathCreateMutable()
                CGPathAddArc(path, nil, frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2, radius, 0.0, 2 * CGFloat(M_PI), false)
                CGPathAddRect(path, nil, CGRect.zero(self.frame.size))
                
                mask_layer.backgroundColor = UIColor.blackColor().CGColor
                mask_layer.path = path
                mask_layer.fillRule = kCAFillRuleEvenOdd
                //mask_layer.anchorPoint = CGPointMake(0.5, 0.5)
                //mask_layer.bounds = self.bounds
                
                // Release the path since it's not covered by ARC.
                self.layer.mask = mask_layer
                self.clipsToBounds = true
                return mask_layer
        }
        
        func add_horizontal_gradient(colors: [CGColor], frame: CGRect)
        {
                let gradient : CAGradientLayer = CAGradientLayer()
                gradient.frame = frame
                gradient.colors = colors
                gradient.masksToBounds = true
                gradient.startPoint = CGPointMake(0.0, 0.5)
                gradient.endPoint = CGPointMake(1.0, 0.5)
                //[gradientLayer setStartPoint:CGPointMake(0.0, 0.5)];
                //[gradientLayer setEndPoint:CGPointMake(1.0, 0.5)];
                self.layer.masksToBounds = true
                self.layer.insertSublayer(gradient, atIndex: 0)
        }
        
        func add_gradient(colors: [CGColor], frame: CGRect)
        {
                let gradient : CAGradientLayer = CAGradientLayer()
                gradient.frame = frame
                gradient.colors = colors
                gradient.masksToBounds = true
                gradient.startPoint = CGPointMake(0.5, 0.0)
                gradient.endPoint = CGPointMake(0.5, 1.0)
                self.layer.masksToBounds = true
                self.layer.insertSublayer(gradient, atIndex: 0)
        }
        
        func set_clean_anchor_point(anchor_point: CGPoint)
        {
                let old_origin = self.frame.origin
                self.layer.anchorPoint = anchor_point
                let new_origin = self.frame.origin
                
                let transition = CGPointMake (new_origin.x - old_origin.x, new_origin.y - old_origin.y)
                
                self.center = CGPointMake(self.center.x - transition.x, self.center.y - transition.y)
        }
        
        func contains_location(location: CGPoint) -> Bool
        {
                let origin_x = self.frame.origin.x
                let end_x = self.frame.x_end
                if location.x < origin_x || location.x > end_x
                {
                        return false
                }
                
                let origin_y = self.frame.origin.y
                let end_y = self.frame.y_end
                
                if location.y < origin_y || location.y > end_y
                {
                        return false
                }
                
                return true
        }
        
        func align_above(other_origin: CGFloat)
        {
                self.frame.origin.y = other_origin - self.frame.size.height
        }
        
        func remove_all_subviews(recursively: Bool = false)
        {
                for view in self.subviews
                {
                        if recursively
                        {
                                view.remove_all_subviews(true)
                        }
                        view.removeFromSuperview()
                }
        }
        
        func mask(color: UIColor, start_point: CGPoint, end_point: CGPoint)
        {
                let gradient_layer = CAGradientLayer()
                gradient_layer.colors = [UIColor.clearColor().CGColor, color.CGColor]
                gradient_layer.startPoint = start_point
                gradient_layer.endPoint = end_point
                gradient_layer.frame = self.bounds
                self.layer.mask = gradient_layer
                /*
                CAGradientLayer *alphaGradientLayer = [CAGradientLayer layer];
                NSArray *colors = [NSArray arrayWithObjects:
                (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                nil];
                [alphaGradientLayer setColors:colors];
                
                // Start the gradient at the bottom and go almost half way up.
                [alphaGradientLayer setStartPoint:CGPointMake(0.0f, 1.0f)];
                [alphaGradientLayer setEndPoint:CGPointMake(0.0f, 0.6f)];
                
                // Create a image view for the topImage we created above and apply the mask
                statusBarView = [[UIImageView alloc] initWithImage:topImage];
                [alphaGradientLayer setFrame:[statusBarView bounds]];
                */
        }
        
        func make_circle()
        {
                self.layer.cornerRadius = self.frame.size.height/2.0
                self.clipsToBounds = true
        }
        
        func set_shadow(color: UIColor, _ radius: CGFloat = 2.0, _ opacity: Float = 0.7, _ offset: CGSize = CGSizeMake(0.0, 3.0))
        {
                self.layer.masksToBounds = false
                self.layer.shadowColor = color.CGColor
                self.layer.shadowRadius = radius
                self.layer.shadowOpacity = opacity
                self.layer.shadowOffset = offset
                self.layer.shouldRasterize = true
                self.layer.rasterizationScale = UIScreen.mainScreen().scale
        }
        
        func null_shadow()
        {
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
        }
        
        /*func add_shadow(offset: CGSize = CGSizeMake(5.0,5.0), radius: CGFloat = 5.0)
        {
        self.clipsToBounds = false
        /*var new_layer = CALayer()
        new_layer.shadowOpacity = 0.7
        new_layer.shadowColor = UIColor.blackColor().CGColor
        new_layer.shadowOffset = offset
        new_layer.shadowRadius = radius
        self.layer.addSublayer(new_layer)*/
        let shadow_path = UIBezierPath(rect: self.bounds)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowPath = shadow_path.CGPath
        }*/
        
        func screenshot() -> UIImage
        {
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale);
                self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
                let image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext()
                return image
        }
        
        func rotate(reversed: Bool, duration: Double = 0.6, autoreverses: Bool = true)
        {
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.toValue = M_PI * (reversed ? -1 : 1)
                animation.duration = duration
                animation.autoreverses = autoreverses
                animation.repeatCount = HUGE
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                self.layer.addAnimation(animation, forKey: "rotationAnimation")
        }
        
        func rotate_linear(duration: Double, repeat_count: Float = HUGE)
        {
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.toValue = M_PI * 2
                animation.duration = duration
                animation.autoreverses = false
                animation.repeatCount = repeat_count
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                self.layer.addAnimation(animation, forKey: "rotationAnimation")
        }
        
        func rotate(reversed: Bool, repeat_count: Float)
        {
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.toValue = M_PI * (reversed ? -1 : 1)
                animation.duration = 0.6
                animation.autoreverses = true
                animation.repeatCount = repeat_count
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                self.layer.addAnimation(animation, forKey: "rotationAnimation")
        }
        
        func rotate_full(duration: CGFloat = 0.8)
        {
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.toValue = M_PI * 2
                animation.duration = 0.8
                animation.autoreverses = false
                animation.repeatCount = 1.0
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                self.layer.addAnimation(animation, forKey: "rotationAnimation")
        }
        
        func scale(var scale: CGFloat)
        {
                if scale == 0
                {
                        scale = 0.0001
                }
                self.transform = CGAffineTransformMakeScale(scale, scale)
        }
        
        class func animate_with_keyboard(values: (begin_rect: CGRect, end_rect: CGRect, duration: Double, options: UIViewAnimationOptions), animations: () -> Void, completion: ((Bool) -> Void)?)
        {
                UIView.animateWithDuration(values.duration, delay: 0, options: values.options, animations: animations, completion: completion)
        }
        
        func animate_with_spring(scale: CGFloat)
        {
                self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                        {
                                self.scale(scale)
                        }, completion: nil)
        }
        
        func animate_to_point(origin: CGPoint)
        {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                        {
                                self.frame.origin = origin
                        }, completion: nil)
        }
        
        func animate_to_point(origin: CGPoint, completion: ((Bool) -> Void)?)
        {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                        {
                                self.frame.origin = origin
                        }, completion: completion)
        }
        
        func animate_ease_in_out(duration: Double = 0.3, animation: () -> Void)
        {
                UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: animation, completion: nil)
        }
        
        func animate_ease_in_out(animation: () -> Void, completion: ((Bool) -> Void)?, duration: Double, delay: Double = 0.0)
        {
                UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations: animation, completion: completion)
        }
        
        func animate_ease_in(animation: () -> Void)
        {
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: animation, completion: nil)
        }
        
        func animate_ease_in(animation: () -> Void, completion: ((Bool) -> Void)?, duration: Double, delay: Double = 0.0)
        {
                UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: animation, completion: completion)
        }
        
        func animate_ease_in(animation: () -> Void, completion: ((Bool) -> Void)?)
        {
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: animation, completion: completion)
        }
        
        func animate_ease_in_out(animation: () -> Void, completion: ((Bool) -> Void)?)
        {
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: animation, completion: completion)
        }
        
        func animate_ease_out(animation: () -> Void, completion: ((Bool) -> Void)?)
        {
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: animation, completion: completion)
        }
        
        func animate_ease_out(animation: () -> Void, completion: ((Bool) -> Void)?, duration: Double, delay: Double = 0.0)
        {
                UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: animation, completion: completion)
        }
        
        func animate_spring_quick(animation: () -> Void, completion: ((Bool) -> Void)?)
        {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations: animation, completion: completion)
        }
        
        func animate_spring(animation: () -> Void)
        {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                        animation, completion: nil)
        }
        
        func animate_spring(animation: () -> Void, completion: ((Bool) -> Void)?)
        {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                        animation, completion: completion)
        }
        
        func animate_spring(animation: () -> Void, completion: ((Bool) -> Void)?, duration: Double)
        {
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                        animation, completion: completion)
        }
        
        func animate_scale_spring(var scale: CGFloat, completion: ((Bool) -> Void)?)
        {
                scale = max(0.0001,scale)
                self.animate_spring(
                        {
                                self.scale(scale)
                        }, completion: completion)
        }
        
        class func thin_border(thickness: CGFloat = border_thin_length) -> UIView
        {
                let border = UIView(frame: CGRectMake(0, 0, screen_size().width, border_thin_length))
                border.backgroundColor = .border_gray()
                return border
        }
        
        func add_dashed_border(color: UIColor) {
                let color = color.CGColor
                
                let shapeLayer:CAShapeLayer = CAShapeLayer()
                let frameSize = self.frame.size
                let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
                
                shapeLayer.bounds = shapeRect
                shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
                shapeLayer.fillColor = UIColor.clearColor().CGColor
                shapeLayer.strokeColor = color
                shapeLayer.lineWidth = 2
                shapeLayer.lineJoin = kCALineJoinRound
                shapeLayer.lineDashPattern = [6,3]
                shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: self.layer.cornerRadius).CGPath
                
                self.layer.addSublayer(shapeLayer)
        }
                
}