//
//  DemoModels.swift
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/20.
//  Copyright © 2020 swx. All rights reserved.
//

import Foundation
import UIKit
import HandyJSON

class PSHeaderModel: NSObject, PSGroupItem, HandyJSON {
    
    class func modelWithTitle(_ titles: [String]?)->PSHeaderModel {
        let model = PSHeaderModel.init()
        model.values = titles
        return model
    }
    
    fileprivate var name: String?
    fileprivate var values: [String]?
    fileprivate var subItems: [PSGroupItem]?
    fileprivate var isExpand: Bool! = false
    fileprivate lazy var viewContent: UIView = {
        var view = UIView.init()
        view.addSubview(self.viewItems)
        let superview = view
        self.viewItems.snp.makeConstraints { (make) in
            make.top.equalTo(superview).offset(4)
            make.bottom.equalTo(superview).offset(-4)
            make.leading.trailing.equalTo(superview)
        }
        return view
    }()
    fileprivate lazy var viewItems: PSGroupView = {
        let view = PSGroupView.viewForHeader()
        view.loadDataBlock = { [weak self] ()->(PSGroupItem?) in
            return self
        }
        view.columnWidthBlock = { [weak self] (column)->(Double) in
            var width = 0.0
            if let block = self?.columnWidthBlock {
                width = block(column)
            }
            return width
        }
        view.touchedBlock = { [weak self] (obj) in
            self?.switchExpend(expand: !(self?.isExpand)!)
            self?.parent?.reloadChildren()
            if let block = self?.touchedBlock {
                block(obj)
            }
        }
        return view
    }()
    
    required override init() {
        super.init()
    }
    
    func loadItems(items: [PSGroupItem]?) -> Void {
        self.subItems = items
        for obj:PSGroupItem in items! {
            obj.parent = self
            obj.columnWidthBlock = {[weak self] (column)->(Double) in
                var width = 0.0
                if let block = self?.columnWidthBlock {
                    width = block(column)
                }
                return width
            }
        }
    }
    
    // MARK: PSGroupItem
    var touchedBlock: ((PSGroupItem?) -> (Void))?
    var columnWidthBlock: ((Int) -> (Double))?
    weak var parent: PSGroupItem?
    
    func textValues() -> [String]? {
        return self.values
    }
    
    func items() -> [PSGroupItem]? {
        return self.subItems
    }
    
    func digitalDepth() -> Int {
        return 0
    }
    
    func getView() -> UIView {
        return self.viewContent
    }
    
    func reloadView() {
        self.viewItems.reloadData()
    }
    
    func reloadChildren() {
        self.viewItems.reloadChildren()
    }
    
    func switchExpend(expand: Bool) {
        self.viewItems.switchExpand(expand)
    }
    
    func isBottomLevelItem() -> Bool {
        return false
    }
}
