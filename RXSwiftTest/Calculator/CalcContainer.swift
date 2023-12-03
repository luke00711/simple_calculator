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
        
        reloadConstraint()
       receivedRotation()
        
        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification).take(until: rx.deallocated).subscribe(onNext: {[weak self] notif in
            
            self?.receivedRotation()
        }).disposed(by: disposeBag)
      
    }
    
    //通知监听触发的方法
    @objc func receivedRotation(){
        if(UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight){
            secondCalc.isHidden = false// Device oriented horizontally, home button on the right
            swapView.isHidden = false
            firstCalc.changeToHalfScreen()
            swapView.reloadButtonPos()
            secondCalc.changeToHalfScreen(fitRight: true)
        }else{
            secondCalc.isHidden = true
            swapView.isHidden = true
            firstCalc.showFullscreen()

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
