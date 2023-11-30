//
//  CalcModel.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 27/11/23.
//

import Foundation
import RxSwift
enum CalcAction {
    case Add
    case Substract
    case Divide
    case Value
    case ClearAll
    case PosMin
    case Mod
    case Multiply
    case Equal
    case Dot
    
    func calculateResult(  totalValue : String?,   nextValue : String) -> String{
        if(totalValue == nil || totalValue?.isEmpty == true){
            return nextValue
        }
        switch(self){
        case .Add:
            do {
               return NSDecimalNumber.addingValueFrom(totalValue: totalValue, nextValue: nextValue)
            }
        case .Substract:
            do {
                return NSDecimalNumber.subtractValueFrom(totalValue: totalValue, nextValue: nextValue)
            }
        case .Divide:
            do {
                return NSDecimalNumber.divideValueFrom(totalValue: totalValue, nextValue: nextValue)
            }
    
        case .Multiply:
            do {
                return NSDecimalNumber.multiplyValueFrom(totalValue: totalValue, nextValue: nextValue)
            }
    
        default:
            break
        }
        
        return "0"
    }

    
    func operatable() -> Bool {
        if(self == .Add || self == .Divide || self == .Multiply || self == .Substract ){
            return true
        }
        return false
    }
    
    func prioritize() -> Bool {
        if(self == .Divide || self == .Multiply  ){
            return true
        }
        return  false
    }
    
    func checkEmpty() -> Bool {
        if(self != .Value){
            return true
        }
        return  false
    }
    
}

struct CalcModel : Equatable{
    static func == (lhs: CalcModel, rhs: CalcModel) -> Bool {
        return lhs.action == rhs.action || lhs.value == rhs.value
    }
    
    var value : String = ""
    var action : CalcAction
    var currentWrapper : CalcWrapper?
     let actionInfoSubject = PublishSubject<CalcModel>()
    
    let errorResult: Observable<Error>? = nil
    
    init(value: String? = nil, action: CalcAction, wrapper : CalcWrapper? = nil) {
        self.value = value ?? ""
        self.action = action
        self.currentWrapper = wrapper
       
     }
    
    func refereshLabel () -> Bool {
        return action == CalcAction.ClearAll
    }
    
    func text()-> String{
       switch action{
       case CalcAction.ClearAll:
           return currentWrapper?.totalValue.isEmpty  == true ? "AC" : "C"
       case CalcAction.PosMin:
           return "+/-"
       case CalcAction.Mod:
           return "%"
       case CalcAction.Divide:
           return "÷"
        case CalcAction.Add:
           return "+"
       case CalcAction.Multiply:
           return "X"
        case CalcAction.Substract:
            return "-"
       case CalcAction.Dot:
           return "."
       case CalcAction.Equal:
           return "="
        case CalcAction.Value:
           return value
       }

    }
    
    
    
   func backgroundColor()-> UIColor{
        if(action == CalcAction.Value || action == CalcAction.Dot) {
            return UIColor.darkGray
        }
        
        if(action == CalcAction.ClearAll || action == CalcAction.PosMin || action == CalcAction.Mod) {
            return UIColor.lightGray
        }
        
        return UIColor.systemOrange
    }
        
        
    func performAction(){
        actionInfoSubject.onNext(self)
    }
    
}

