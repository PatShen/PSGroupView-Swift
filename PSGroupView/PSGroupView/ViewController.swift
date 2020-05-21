//
//  ViewController.swift
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/19.
//  Copyright © 2020 swx. All rights reserved.
//

import UIKit
import SnapKit
import HandyJSON
import SwiftyJSON

class ViewController: UIViewController {
    lazy var mdlHeader: PSHeaderModel = {
        let titles = ["标题1","标题2","标题3","标题4"]
        let model:PSHeaderModel = .modelWithTitle(titles)
        model.columnWidthBlock = { (column)->(Double) in
            var width = 0.0
            switch column {
            case 0: width = 116.0
            case 1: width = 72.5
            case 2: width = 72.5
            case 3: width = 94.0
            default:
                width = 0.0
            }
            return width
        }
        model.touchedBlock = { [weak self] (PSGroupItem) in
            self?.mdlHeader.reloadView()
        }
        return model
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .init(white: 0.9, alpha: 1.0)
        self.loadData()
        
        let view = self.mdlHeader.getView()
        self.view.addSubview(view)
        guard let superview = self.view else { return }
        view.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(superview.safeAreaLayoutGuide.snp.top).offset(10.0)
                make.leading.equalTo(superview.safeAreaLayoutGuide.snp.leading).offset(10.0)
                make.trailing.equalTo(superview.safeAreaLayoutGuide.snp.trailing).offset(-10.0)
                make.bottom.lessThanOrEqualTo(superview.safeAreaLayoutGuide.snp.bottom).offset(-10.0)
            } else {
                make.top.equalTo(superview.snp.top).offset(10.0)
                make.leading.equalTo(superview.snp.leading).offset(10.0)
                make.trailing.equalTo(superview.snp.trailing).offset(-10.0)
                make.bottom.lessThanOrEqualTo(superview.snp.bottom).offset(-10.0)
            }
        }
        self.mdlHeader.reloadView()
        self.mdlHeader.switchExpend(expand: true)
    }
    
    fileprivate func loadData() {
        self.mdlHeader.loadItems(items: self.loadTestData())
        self.mdlHeader.reloadView()
    }
    
    fileprivate func loadTestData() -> [PSGroupItem] {
        
//        let jsonString = "[{\"name\":\"上海二公司\",\"subItems\":[{\"members\":[{\"name\":\"啊啊啊\",\"values\":[\"20\",\"60\",\"4.5\"]},{\"name\":\"小李子\",\"values\":[\"20\",\"60\",\"4.5\"]}],\"name\":\"一片区\",\"values\":[\"20\",\"60\",\"4.5\"]}],\"values\":[\"20\",\"60\",\"4.5\"]},{\"members\":[{\"name\":\"小1\",\"values\":[\"1\",\"2\",\"3\"]}],\"name\":\"上海三公司\",\"subItems\":[{\"name\":\"子部门1\",\"values\":[\"25\",\"80\",\"4.5\"]},{\"name\":\"子部门2\",\"subItems\":[{\"members\":[{\"name\":\"大张子\",\"values\":[\"20\",\"60\",\"4.5\"]},{\"name\":\"狗蛋\",\"values\":[\"20\",\"60\",\"4.5\"]}],\"name\":\"子部门1\",\"values\":[\"25\",\"80\",\"4.5\"]}],\"values\":[\"25\",\"80\",\"4.5\"]}],\"values\":[\"25\",\"80\",\"4.5\"]}]"
        
        let array =
            [
                ["name":"上海二公司","values":["20","60","4.5"],
                 "members":[["name":"小李子","values":["20","60","4.5"]]],
                 "subItems":[["name":"一片区","values":["20","60","4.5"]]]
                ],
                ["name":"上海二公司","values":["20","60","4.5"],
                 "members":[["name":"小李子","values":["20","60","4.5"]]],
                 "subItems":[["name":"一片区","values":["20","60","4.5"]]]
                ],
        ]
        
        var result = [PSGroupItem]()
        for dict:[String:Any] in array {
            if let model = PSDepModel.deserialize(from: dict) {
                result.append(model)
            }
        }

        return result
    }
    
}

