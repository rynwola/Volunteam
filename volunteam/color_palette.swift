//color_palette.swift

import UIKit

extension UIColor
{
        class func rainbow() -> [UIColor]
        {
                return [.navy_blue(), .msu_green(), .warm_blue(), .green(), .vibrant_green(), .umich_blue(), .logo_blue()]
        }
        class func logo_blue() -> UIColor
        {
                return UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 139.0/255.0, alpha: 1)
        }
        
        class func heart_red() -> UIColor
        {
                return UIColor(red: 255.0/255.0, green: 38.0/255.0, blue: 31.0/255.0, alpha: 1)
        }
        
        class func logo_pink() -> UIColor
        {
                return UIColor(red: 248.0/255.0, green: 121.0/255.0, blue: 133.0/255.0, alpha: 1)
        }
        
        class func orange() -> UIColor
        {
                return UIColor(red: 251.0/255.0, green: 100.0/255.0, blue: 27.0/255.0, alpha: 1)
        }
        
        class func neon_blue() -> UIColor
        {
                return UIColor(red: 2.0/255.0, green: 220.0/255.0, blue: 230.0/255.0, alpha: 1)
        }
        
        class func navy_blue() -> UIColor
        {
                return UIColor(red: 63.0/255.0, green: 95.0/255.0, blue: 129.0/255.0, alpha: 1)
        }
        
        class func msu_green() -> UIColor
        {
                return UIColor(red: 0.0/255.0, green: 114.0/255.0, blue: 63.0/255.0, alpha: 1)//UIColor(red: 24.0/255.0, green: 69.0/255.0, blue: 59.0/255.0, alpha: 1)
        }
        
        class func umich_blue() -> UIColor
        {
                return UIColor(red: 0.0/255.0, green: 39.0/255.0, blue: 76.0/255.0, alpha: 1)
        }
        
        class func umich_maize() -> UIColor
        {
                return UIColor(red: 255.0/255.0, green: 203.0/255.0, blue: 5.0/255.0, alpha: 1)
        }
        
        class func warm_blue() -> UIColor
        {
                return UIColor(red: 25.0/255.0, green: 135.0/255.0, blue: 180.0/255.0, alpha: 1)
        }
        
        class func green() -> UIColor //primary
        {
                return UIColor(red: 63.0/255.0, green: 190.0/255.0, blue: 33.0/255.0, alpha: 1)
        }
        
        class func vibrant_green() -> UIColor //secondary green
        {
                return UIColor(red: 159.0/255.0, green: 223.0/255.0, blue: 16.0/255.0, alpha: 1)
        }
        
        class func yellow() -> UIColor
        {
                return UIColor(red: 238.0/255.0, green: 235.0/255.0, blue: 40.0/255.0, alpha: 1)
        }
        
        class func dark_gray() -> UIColor //some text
        {
                //return UIColor(red: 53.0/255.0, green: 65.0/255.0, blue: 71.0/255.0, alpha: 1)
                return UIColor(red: 119.0/255.0, green: 121.0/255.0, blue: 124.0/255.0, alpha: 1)
        }
        
        class func off_black() -> UIColor
        {
                return UIColor(red: 53.0/255.0, green: 65.0/255.0, blue: 71.0/255.0, alpha: 1)
        }
        
        class func medium_gray(alpha: CGFloat = 1) -> UIColor //
        {
                return UIColor(red: 168.0/255.0, green: 168.0/255.0, blue: 171.0/255.0, alpha: alpha)
        }
        
        class func border_gray() -> UIColor //borders
        {
                return UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)
        }
        
        class func light_gray() -> UIColor //background gray
        {
                return UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)
        }
        
        class func frosted_white() -> UIColor
        {
                return UIColor(white: 1, alpha: 0.9)
        }
        
        class func light_white() -> UIColor
        {
                return UIColor(white: 1, alpha: 0.4)
        }
        
        class func tony_gray() -> UIColor
        {
                return UIColor(red: 38.0/255.0, green: 42.0/255.0, blue: 42.0/255.0, alpha: 1)
        }
        
        class func transparent_black(alpha: CGFloat = 0.75) -> UIColor
        {
                return UIColor(white: 0.0, alpha: alpha)
        }
        
        class func white_smoke() -> UIColor //background
        {
                return UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
        }
        
        class func alizarin() -> UIColor //red
        {
                return UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1)
        }
        
        class func sun_flower() -> UIColor //yellow
        {
                return UIColor(red: 241.0/255.0, green: 196.0/255.0, blue: 239.0/255.0, alpha: 1)
        }
        
        class func soft_blue() -> UIColor //blue
        {
                return UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        }
        
        class func concrete() -> UIColor //gray
        {
                return UIColor(red: 151.0/255.0, green: 163.0/255.0, blue: 163.0/255.0, alpha: 1)
        }
        /*class func torquise() -> UIColor
        {
        return UIColor(red: 26.0/255.0, green: 159.0/255.0, blue: 179.0/255.0, alpha: 1)
        }*/
        
        /*class func tan() -> UIColor
        {
        return UIColor(red: 218.0/255.0, green: 186.0/255.0, blue: 137.0/255.0, alpha: 1)
        }*/
}