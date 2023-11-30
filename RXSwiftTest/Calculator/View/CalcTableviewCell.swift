//
//  CalcTableviewCell.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 28/11/23.
//

import Foundation
import UIKit



class CalcTableviewCell : UITableViewCell {
    var items  : [CalcModel] = []
    var acModelView : CalcButtonContent?
    let padding   = 5.0
        
    var stackView = {
        let t = UIStackView()
        t.distribution = .fillEqually
        t.axis = .horizontal
        t.alignment = .center
        t.spacing = 5
        
        return t
    }()
    
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initUI()
    }
     
    func configureWith(tv : UITableView, items  : [CalcModel] = [], lastRow: Bool = false){
        stackView.removeFullyAllArrangedSubviews()
        if(lastRow){
            let temp = UIView()
            stackView.addArrangedSubview(temp)
            temp.snp.makeConstraints { make in
                make.top.equalTo(stackView).offset(padding)
            }
            
            for item in 0..<items.count {
                let model = items[item]
                let view = CalcButtonContent()
                view.model = model
                view.configure(model: model)
                temp.addSubview(view)
              
                if(item == 0){
                    view.snp.makeConstraints { make in
                        make.left.equalTo(temp)
                       
                        make.top.bottom.equalTo(temp)
                        make.width.equalTo(contentView).dividedBy(2).offset(-10)
                    }
                }else{
                    view.snp.makeConstraints { make in
                        make.left.equalTo(temp.subviews[item-1].snp.right).offset(padding)
                        make.top.bottom.equalTo(temp)
                        make.width.equalTo(contentView).dividedBy(4.3)
                    }
                }
            }
            return
        }
        
        for item in 0..<items.count {
            let model = items[item]
            let view = CalcButtonContent()
            view.configure(model: model)
            if(model.refereshLabel()){
                acModelView = view
            }
            stackView.addArrangedSubview(view)
            
            model.actionInfoSubject.asObservable().subscribe( onNext :{ _ in
              let cell :CalcTableviewCell? =   tv.cellForRow(at: IndexPath(row: 0, section: 0)) as? CalcTableviewCell//取第一个row
                cell?.acModelView?.refreshLabel()
           }).disposed(by: disposeBag)
            
            view.snp.makeConstraints { make in
                make.top.equalTo(stackView).offset(padding)
                make.bottom.equalTo(stackView).offset(-padding)
          
            }
        }
        
    }
    
    func initUI(){
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(padding)
            make.right.equalTo(self.contentView).offset(-padding)
            make.bottom.top.equalTo(self.contentView)
        }
        backgroundColor = UIColor.black
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
