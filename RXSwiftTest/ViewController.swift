//
//  ViewController.swift
//  RXSwiftTest
//
//  Created by Lukman Lawi on 17/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let container = CalContainer()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(container)
        container.matchToSuperview()
//      
        // Do any additional setup after loading the view.
    }
    

}

