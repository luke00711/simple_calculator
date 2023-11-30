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
 
     let actionInfoSubject = PublishSubject<CalcModel>()
    
    let errorResult: Observable<Error>? = nil
    
    init(value: String? = nil, action: CalcAction) {
        self.value = value ?? ""
        self.action = action
       
     }
    
    func text()-> String{
       switch action{
       case CalcAction.ClearAll:
           return "AC"
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

class CalcWrapper {
    var lastAction : CalcModel = CalcModel(action: CalcAction.Equal)
    var totalValue : String = ""
    var lastValue : String = ""
    var equationValue  : String = ""
    var equation : Array<CalcModel>  = []
    var actionInfo: Array<Observable<CalcModel>> = []
    
    var firstRow : [CalcModel] = [CalcModel(action: CalcAction.ClearAll),CalcModel(action: CalcAction.PosMin),CalcModel(action: CalcAction.Mod),CalcModel(action: CalcAction.Divide)]
    
    var secondRow : [CalcModel] = [CalcModel(value:"7",action: CalcAction.Value), CalcModel(value:"8",action: CalcAction.Value), CalcModel(value:"9",action: CalcAction.Value),
                                   CalcModel(action: CalcAction.Multiply)]
    
    var thirdRow : [CalcModel] = [CalcModel(value:"4",action: CalcAction.Value), CalcModel(value:"5",action: CalcAction.Value), CalcModel(value:"6",action: CalcAction.Value),
                                   CalcModel(action: CalcAction.Substract)]
    
    var fourthRow : [CalcModel] = [CalcModel(value:"1",action: CalcAction.Value), CalcModel(value:"2",action: CalcAction.Value), CalcModel(value:"3",action: CalcAction.Value),CalcModel(action: CalcAction.Add)]
    
    var fifthRow : [CalcModel] = [CalcModel(value:"0",action: CalcAction.Value), CalcModel(action: CalcAction.Dot), CalcModel(action: CalcAction.Equal)]
    
    var allContent : [[CalcModel]] = []
    var disposeBag = DisposeBag()
    let totalInfoSubject = PublishSubject<String>()
    let equationInfoSubject = PublishSubject<String>()
    
    init() {
        
        firstRow.forEach { model in
            actionInfo.append(model.actionInfoSubject.asObservable())
        }
        
        secondRow.forEach { model in
            actionInfo.append(model.actionInfoSubject.asObservable())
        }
        
        thirdRow.forEach { model in
            actionInfo.append(model.actionInfoSubject.asObservable())
        }
        
        fourthRow.forEach { model in
            actionInfo.append(model.actionInfoSubject.asObservable())
        }
        
        fifthRow.forEach { model in
            actionInfo.append(model.actionInfoSubject.asObservable())
        }
        
        actionInfo.forEach { obss in
            obss.subscribe { [weak self] model in
                self?.performSectionOn(model: model)
                self?.reloadContent( value: self?.totalValue)
            }.disposed(by: disposeBag)
        }
        allContent = [firstRow,secondRow, thirdRow, fourthRow,fifthRow]
       
    }
    
    func performSectionOn(model : CalcModel){
        
            
       
        if(model.action.checkEmpty() && totalValue.isEmpty){
           return
        }
        
        if(model.action.operatable()){
            insertValue()
            insertSymbol(model: model)
            totalValue = ""
            equationValue = ""
            lastAction = model
        }
        
        
        switch(model.action){
         case .Add:
           
            
            break
        case .Substract:
            break
        case .Divide:
            break
        case .Value: do {
            if(!totalValue.isEmpty &&  totalValue.doubleValue() == 0 && !totalValue.contains(".")){
                return
            }
            totalValue.append(model.value)
            lastValue = totalValue
         }
          
            break
        case .ClearAll:
            totalValue = ""
            equationValue = ""
            equation.removeAll()
            break
        case .PosMin:
            do {
                
                 equation.removeAll()
                let temp = "\(NSDecimalNumber(string: totalValue).doubleValue * -1 )"
                   totalValue = temp.doubleToStringPrecision(ref: temp, secondRef: temp)
                equation.append(CalcModel(value: totalValue, action: CalcAction.Value))
            }

            break
        case .Mod:
            do {
                
                 equation.removeAll()
                totalValue = NSDecimalNumber.divideValueFrom(totalValue: totalValue, nextValue: "100",isMod: true)
                equation.append(CalcModel(value: totalValue, action: CalcAction.Value))
            }
            break
        case .Multiply:
            
            break
        case .Equal:
            do {
                
             if(lastAction.action.operatable()){ //计算
                 if(equation.last?.action != lastAction.action){ //对缓存的操作符进行处理
                         insertSymbol(model: lastAction)
                  }
                 
                 insertValue()
                 calculateResult()
             }
                

            }
            break
        case .Dot:
           do {
               if(!totalValue.isEmpty && !totalValue.contains(".")){
                   totalValue.append(".")
               }
            }
            break
        }
    }
    
    func insertValue(){
        if(equation.last?.action.operatable() == true || equation.isEmpty){
            equation.append(CalcModel(value: lastValue, action: CalcAction.Value))
        }
       
    }
    
    func insertSymbol(model : CalcModel){
        if(model.action.operatable()){
            equation.append(model)
        }
      
    }
    
    func calculateResult(){
        var totalResult = ""
        equationValue = ""
        var tempArr = equation
        var calculateDigit : Array<Int> = []
        var filteredArr: Array<CalcModel> = []
   
        
        var count : Int = 0
        var existPrioritize = false
        while(count < equation.count-1){
           
            let model = equation[count]
            if(totalResult.isEmpty &&  model.action == CalcAction.Value && equation[count+1].action.prioritize()){
                totalResult = model.value
            }
            
            if(model.action.prioritize()){
                existPrioritize = true
                if(totalResult.isEmpty){
                    totalResult = equation[count-1].value
                }
                calculateDigit.append(count)
                calculateDigit.append(count-1)
                calculateDigit.append(count+1)
               totalResult = model.action.calculateResult(totalValue: totalResult, nextValue: equation[count+1].value)
                count = count + 1
             }
              
            
            if (model.action.operatable()  && !model.action.prioritize() && !totalResult.isEmpty && existPrioritize){
              
                tempArr.append(CalcModel(action: .Add))
                tempArr.append(CalcModel(value: totalResult, action: .Value))
                
                 totalResult = ""
                 existPrioritize = false
              }
            
            if ( (existPrioritize && count ==  equation.count-1) || (count == tempArr.count-1)){ //最后计算的值或者普通运算符
                  existPrioritize = false
                  print("最后搜索")
                    tempArr.append(CalcModel(action: .Add))
                    tempArr.append(CalcModel(value: totalResult, action: .Value))
                }
       
            count += 1
        
        }
        totalResult = ""
        
     
        tempArr.enumerated().forEach { (index,elem) in
            if(calculateDigit.firstIndex(of: index ) ?? -1 < 0){
                filteredArr.append(elem )
            }
        }
         
         count  = 0
        
        while(count < filteredArr.count-1){
            var model = filteredArr[count]
            if(count == 0 && model.action == CalcAction.Value){
                totalResult = model.value
            }
            if(totalResult.isEmpty && model.action == CalcAction.Substract){
                totalResult = "-\(filteredArr[count+1].value)"
                 model = filteredArr[count+1]
            }
            
            if(model.action.operatable()){
                for item in count+1 ..< filteredArr.count {
                    if(filteredArr[item].action == CalcAction.Value){
                        totalResult =   model.action.calculateResult(totalValue: totalResult, nextValue: filteredArr[item].value)
                        count = item
                        break
                    }
                    
                }
            }
            count += 1
        
        }
        
        
        equation.forEach { model in
            if(model.action != CalcAction.Value){
                equationValue.append(model.text())
            }else{
                equationValue.append(model.value)
           }
        }
        
        totalValue = totalResult
//        print("\(equationValue)")
       
    }
    
    
    func reloadContent(value: String? = ""){
        totalInfoSubject.onNext(value! )
        equationInfoSubject.onNext(equationValue)
    }
    
    
}
