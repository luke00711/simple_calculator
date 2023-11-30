//
//  Calculator.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 27/11/23.
//

import Foundation
import UIKit
import RxSwift


let cellIdentifier = "cellIdentifier"

class CalculatorDisplay : UIView {
    var dataModel : CalcWrapper?
    var contentObservable: Observable<String>? = nil
    var equationObservable: Observable<String>? = nil
    let disposeBag = DisposeBag()
    var contentText = {
        let t = UILabel(frame: CGRect.zero)
        t.textColor = UIColor.white
        t.font = UIFont.boldSystemFont(ofSize: 30)
        return t
    }()
    
    var equationText = {
        let t = UILabel(frame: CGRect.zero)
        t.textColor = UIColor.white
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
    }
    
    convenience init(dataModeL: CalcWrapper) {
        self.init(frame: CGRect.zero)
        self.dataModel = dataModeL
        initContent()
    }
    
    func initContent(){
        addSubview(contentText)
        contentText.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-50)
            make.right.equalTo(self).offset(-10)
        }
        
        
        addSubview(equationText)
        equationText.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-20)
            make.left.equalTo(self).offset(10)
        }
        
        initObserver(dataModel: dataModel)
    }
    
    
    func initObserver(dataModel : CalcWrapper?){
        self.dataModel = dataModel
        contentObservable = dataModel?.totalInfoSubject.asObservable()
        contentObservable?.observe(on: MainScheduler.instance).subscribe( onNext :{ [weak self] result in
            self?.contentText.text = result
        }).disposed(by: disposeBag)
        
        equationObservable = dataModel?.equationInfoSubject.asObservable()
        equationObservable?.observe(on: MainScheduler.instance).subscribe( onNext :{ [weak self] result in
            self?.equationText.text = result
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CalculatorContent : UIView {
    var dataModel : CalcWrapper?
    let calculator_items : [[CalcModel]] = []
    
    var tv = {
        let tv =  UITableView()
       tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.register(CalcTableviewCell.self, forCellReuseIdentifier: cellIdentifier)
        let background = UIView(frame: UIScreen.main.bounds)
        background.backgroundColor = UIColor.black
        tv.backgroundView = background
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    convenience init(dataModeL: CalcWrapper) {
        self.init(frame: CGRect.zero)
        self.dataModel = dataModeL
        backgroundColor = UIColor.red
       initContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initContent(){
        tv.dataSource = self
        tv.delegate = self
        addSubview(tv)
        tv.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.width.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
        
}
extension CalculatorContent : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
       
        let height = Calculator.CONTENT_HEIGHT()
        return  height/5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CalcTableviewCell?
        if(cell == nil){
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier) as? CalcTableviewCell
        }
        cell?.configureWith(items: dataModel!.allContent[indexPath.section], lastRow: indexPath.section == dataModel!.allContent.count-1)
       
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel?.allContent.count ?? 0
    }
    
}


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

