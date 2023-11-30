//
//  CalcCollectionViewCell.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 28/11/23.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift



class CalcCollectionViewCell : UICollectionViewCell{
    var model : CalcModel? = nil
    let view = CalcButtonContent(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view)
        view.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.height.equalTo(self).offset(-5)
        }
     
    }
    
    override func layoutSubviews() {
        view.configure(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
