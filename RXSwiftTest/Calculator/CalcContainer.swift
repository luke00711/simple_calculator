//
//  CalcContainer.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 27/11/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit


class SwapView : UIView {
    var leftArrow = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setImage(UIImage (named: "left_arrow"), for: .normal)
         
      return button
    }()
    
    var rightArrow = {
       let button = UIButton()
        button.layer.cornerRadius = 10
        button.setImage(UIImage (named: "right_arrow"), for: .normal)
        
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
                make.width.equalTo(content!.snp.width).dividedBy(4) // 10 是padding
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

class CalContainer : UIView{
    let firstCalc = Calculator()
    let secondCalc = Calculator()
    let swapView = SwapView()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        
        addSubview(firstCalc)
        addSubview(secondCalc)
        addSubview(swapView)
        

        swapView.leftArrow.rx.tap.subscribe(onNext: { [weak self] in
            self?.firstCalc.swapValue(dataModel: self?.secondCalc.dataModel)
        }).disposed(by: disposeBag)
        
        swapView.rightArrow.rx.tap.subscribe(onNext: { [weak self] in
            self?.secondCalc.swapValue(dataModel: self?.firstCalc.dataModel)
        }).disposed(by: disposeBag)
        
        
        swapView.clearButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.firstCalc.clearValue(dataModel: self?.secondCalc.dataModel)
        }).disposed(by: disposeBag)
        
        
       receivedRotation()
        
        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification).take(until: rx.deallocated).subscribe(onNext: {[weak self] notif in
            
            self?.receivedRotation()
        }).disposed(by: disposeBag)
      
    }
    
    //通知监听触发的方法
    @objc func receivedRotation(){
        if(UIDevice.current.orientation == UIDeviceOrientation.portrait){
            secondCalc.isHidden = true
            swapView.isHidden = true
            firstCalc.showFullscreen()
         
        }else if(UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight){
            secondCalc.isHidden = false// Device oriented horizontally, home button on the right
            swapView.isHidden = false
            firstCalc.changeToHalfScreen()
            swapView.reloadButtonPos()
            secondCalc.changeToHalfScreen(fitRight: true)
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadConstraint(){
        firstCalc.matchToSuperview()
        secondCalc.changeToHalfScreen(fitRight: true)
        swapView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.center.equalTo(self)
            make.top.bottom.equalTo(self)
        }
        
    }
    
}
