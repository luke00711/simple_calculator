//
//  UIViewExtension.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 27/11/23.
//

import Foundation
import UIKit
import SnapKit
extension UIView {
    
    func matchToSuperview(){
        snp.removeConstraints()
        snp.makeConstraints { make in
            make.left.equalTo(superview!)
            make.right.equalTo(superview!)
            make.top.equalTo(superview!)
            make.bottom.equalTo(superview!)
        }
    }
    func top() -> CGFloat{
        return frame.origin.y
    }
    
    func width() -> CGFloat{
        return frame.size.width
    }
    
    func height() -> CGFloat{
        return frame.size.height
    }
    
    
}

extension UIScreen {
   
    
    func safeArea() -> CGFloat {
        return UIDevice.current.isiPhoneXorLater() ? 60 : 0
    }
    
 
    func width() -> CGFloat{
        return (UIScreen.main.bounds.size.width <  UIScreen.main.bounds.size.height ?  UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width)
    }
    
    func height() -> CGFloat{
        if UIDevice.current.orientation.isLandscape {
      
            let height : CGFloat = UIScreen.main.bounds.size.height >  UIScreen.main.bounds.size.width ?  UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
            
            return height +  safeArea()
            // Landscape mode
        } else {
        

            let height : CGFloat = UIScreen.main.bounds.size.height <  UIScreen.main.bounds.size.width ?  UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
            
            return height - safeArea()
            // Portrait mode
        }
    }
    
}

extension UIDevice{
//判断设备是不是iPhoneX以及以上
 public func isiPhoneXorLater() ->Bool{
     let screenHieght = UIScreen.main.nativeBounds.size.height
   return screenHieght >= 1624
 }

    public class func currentOrientation() -> UIDeviceOrientation {
        return  UIDevice.current.orientation
    }
}

extension UITableView {

    func addTopBounceAreaView(color: UIColor = .red) {
        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height

        let view = UIView(frame: frame)
        view.backgroundColor = color

        self.addSubview(view)
    }
}

extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
}

