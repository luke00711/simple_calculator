//
//  CalculatorDisplay.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 30/11/23.
//

import Foundation
import UIKit
import RxSwift

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
