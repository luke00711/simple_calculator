//
//  Calculator.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 27/11/23.
//

import Foundation
import UIKit
import RxSwift

class Calculator : UIView{
    var dataModel = CalcWrapper()
    var calcDisplay: CalculatorDisplay?
    var calcContent : CalculatorContent?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        calcDisplay = CalculatorDisplay(dataModeL: dataModel)
        calcContent = CalculatorContent(dataModeL: dataModel)
        backgroundColor = UIColor.black
        addSubview(calcDisplay!)
        addSubview(calcContent!)
    }
    
    func reloadSubContraint(isHalf : Bool? = false){
        calcDisplay?.snp.removeConstraints()
        calcDisplay?.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(isHalf == true ? Calculator.DISPLAY_HEIGHT()/2  : Calculator.DISPLAY_HEIGHT())
        }

        calcContent?.snp.removeConstraints()
        calcContent?.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(calcDisplay!.snp.bottom)
            make.height.equalTo( Calculator.CONTENT_HEIGHT())
        }
       calcContent?.tv.reloadData()
    }
    
    func swapValue(dataModel : CalcWrapper?){
       
        let backUpValue = self.dataModel.totalValue
        let backUpEquation = self.dataModel.equation
        let equationValue = self.dataModel.equationValue
        
        if((dataModel) != nil){
            
            self.dataModel.equation = dataModel?.equation ?? []
            self.dataModel.totalValue = dataModel?.totalValue ?? ""
            self.dataModel.equationValue = dataModel?.equationValue ?? ""
            
            dataModel?.totalValue = backUpValue
            dataModel?.equation = backUpEquation
            dataModel?.equationValue = equationValue

            dataModel?.reloadContent(value: dataModel?.totalValue)
            self.dataModel.reloadContent(value: self.dataModel.totalValue)
        }
        
    }
    
    func clearValue(dataModel : CalcWrapper?){
        self.dataModel.equation =  []
        self.dataModel.totalValue =  ""
        self.dataModel.equationValue =  ""
        
        dataModel?.totalValue = ""
        dataModel?.equation = []
        dataModel?.equationValue = ""

        dataModel?.reloadContent(value: dataModel?.totalValue)
        self.dataModel.reloadContent(value: self.dataModel.totalValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}

extension Calculator {
    
    static func DISPLAY_HEIGHT() -> CGFloat {
        return UIScreen.main.height() * (UIDevice.current.orientation.isLandscape ? 0.4 : 0.30)
   }

    static func CONTENT_HEIGHT() -> CGFloat {
        let height : CGFloat =  UIScreen.main.height() - DISPLAY_HEIGHT()
    
        return height + ((!UIDevice.current.isiPhoneXorLater() && UIDevice.currentOrientation().isLandscape) ? 60 : 0)
   }
    
    func showFullscreen(){
        matchToSuperview()
        reloadSubContraint()
    }
    
    func changeToHalfScreen(fitRight : Bool? = false){
        snp.removeConstraints()
        snp.makeConstraints { make in
            if(fitRight ?? false){
                make.right.equalTo(self.superview!).offset(-UIScreen.main.safeArea())
            }else{
                make.left.equalTo(self.superview!).offset(UIScreen.main.safeArea())
            }
            make.top.equalTo(self.superview!)
            make.width.equalTo((UIScreen.main.width()-2*UIScreen.main.safeArea())/2-50)
            make.height.equalTo(UIScreen.main.height())
        }
        reloadSubContraint(isHalf: true)
        
    }
}

