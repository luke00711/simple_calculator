//
//  CalculatorContent.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 30/11/23.
//

import Foundation
import UIKit

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
        cell?.configureWith(tv:tableView, items: dataModel!.allContent[indexPath.section], lastRow: indexPath.section == dataModel!.allContent.count-1)
       
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel?.allContent.count ?? 0
    }
    
}
