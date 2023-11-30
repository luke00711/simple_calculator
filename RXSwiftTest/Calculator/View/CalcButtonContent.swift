//
//  CalcButtonContent.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 28/11/23.
//

import Foundation
import UIKit
import RxSwift
let disposeBag : DisposeBag = DisposeBag()

class CalcButtonContent : UIButton {
    var model : CalcModel? = nil
   
    let container = {
       let t = UIButton()
        t.backgroundColor = UIColor.orange
        t.layer.masksToBounds = true
        t.layer.cornerRadius = 10
        return t
    }()
    
    let label = {
       let t = UILabel()
        t.textColor = UIColor.white
        t.font = UIFont.boldSystemFont(ofSize: 25)
        t.textAlignment = NSTextAlignment.center
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        layer.cornerRadius = 10
        setTitleColor(UIColor.white, for: .normal)
 
         rx.tap.subscribe(onNext: { [weak self] in
            self?.model?.performAction()
         }).disposed(by: disposeBag)

    }
    
    func configure(model:CalcModel?){
        self.model = model
        backgroundColor = model?.backgroundColor()
       setTitle(model?.text(), for: .normal)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

