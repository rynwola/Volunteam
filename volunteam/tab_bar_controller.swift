import UIKit

class tab_bar_controller: UITabBarController
{
        var events_controller: events_view_controller!
        var events_navigation_controller: UINavigationController!
        var me_controller: me_view_controller!
        override func viewDidLoad()
        {
                super.viewDidLoad()
                
                UITabBar.appearance().tintColor = UIColor.blackColor()
                events_controller = events_view_controller()
                events_navigation_controller = UINavigationController(rootViewController: events_controller)
                let background_image_view: UIImageView = UIImageView(image: UIImage(named: "volunteam"))
                background_image_view.frame = CGRectMake((screen_size().width - 30) / 2, 3, 38, 38)
                events_navigation_controller.navigationBar.addSubview(background_image_view)
                me_controller = me_view_controller()
                self.viewControllers = [events_navigation_controller, me_controller]
                
                let tab_images = ["Pinwheel","Fencing"]
                for (index, tab_item) in self.tabBar.items!.enumerate()
                {
                        tab_item.title = tab_names[index]
                        tab_item.image = UIImage(named: tab_images[index])
                }
        }
}