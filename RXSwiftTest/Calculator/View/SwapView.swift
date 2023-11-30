//
//  SwapView.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 30/11/23.
//

import Foundation
import UIKit

class SwapView : UIView {
    var leftArrow = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setImage(UIImage (named: "left_arrow"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
      return button
    }()
    
    var rightArrow = {
       let button = UIButton()
        button.layer.cornerRadius = 10
        button.setImage(UIImage (named: "right_arrow"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
      return button
    }()
    
    
    var clearButton = {
       let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("DEL", for: .normal)
      return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftArrow)
        addSubview(rightArrow)
        addSubview(clearButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadButtonPos(){
         let view : CalContainer? =  superview as? CalContainer
        let content = view?.firstCalc.calcContent?.tv.cellForRow(at: IndexPath(row: 0, section: 0))
        let item = content!.contentView.subviews.first!.subviews.first!
        
        let last_content = view?.firstCalc.calcContent?.tv
        leftArrow.snp.removeConstraints()
            leftArrow.snp.makeConstraints { make in
                make.width.equalTo(item.snp.width) // 10 是padding
                make.height.equalTo(item.snp.height)
                make.top.equalTo(item.snp.top)
                make.centerX.equalTo(self.snp.centerX)
            }
            
            rightArrow.snp.makeConstraints { make in
                make.top.equalTo(leftArrow.snp.bottom).offset(10)
                make.width.equalTo(leftArrow.snp.width)
                make.height.equalTo(leftArrow.snp.height)
                make.centerX.equalTo(self.snp.centerX)
            }
        
        clearButton.snp.makeConstraints { make in
            make.bottom.equalTo(last_content!.snp.bottom).offset(-5)
            make.width.equalTo(leftArrow.snp.width)
            make.height.equalTo(leftArrow.snp.height)
            make.centerX.equalTo(self.snp.centerX)
         }

    }
    
}
