//
//  PSDepModel.swift
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/21.
//  Copyright © 2020 swx. All rights reserved.
//

import Foundation
import SnapKit
import HandyJSON

class PSDepModel: NSObject, PSGroupItem, HandyJSON {
    var depth: Int {
        var value = 0;
        var p = self.parent
        while (p != nil) {
            p = p?.parent;
            value += 1;
        }
        return value;
    }
    
    fileprivate var name: String = ""
    fileprivate var values: [String] = []
    fileprivate var subItems: [PSDepModel] = []
    fileprivate var members: [PSMemberModel] = []
    
    fileprivate lazy var viewItems: PSGroupView = {
        let view = PSGroupView.viewForDepartment()
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
            self?.switchExpend(expand: !(self?.viewItems.isExpand)!)
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
    
    // MARK: PSGroupItem
    var columnWidthBlock: ((Int) -> (Double))?
    var touchedBlock: ((PSGroupItem?) -> (Void))?
    weak var parent: PSGroupItem?
    
    func textValues() -> [String]? {
        var array = [String]()
        array.append(self.name)
        array.append(contentsOf: self.values)
        return array
    }
    
    func items() -> [PSGroupItem]? {
        var array = [PSGroupItem]()
        array.append(contentsOf: self.subItems)
        array.append(contentsOf: self.members)
        return array
    }
    
    func digitalDepth() -> Int {
        return self.depth
    }
    
    func getView() -> UIView {
        return self.viewItems
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
    
    // MARK: HandyJSON
    
    func didFinishMapping() {
        for sub in self.subItems {
            sub.parent = self
            sub.columnWidthBlock = { [weak self] (column) -> (Double) in
                var width = 0.0
                if let block = self?.columnWidthBlock {
                    width = block(column)
                }
                return width
            }
            sub.touchedBlock = { [weak self] (item) -> (Void) in
                self?.parent?.reloadChildren()
                if let block = self?.touchedBlock {
                    block(item)
                }
            }
        }
        
        for sub in self.members {
            sub.parent = self
            sub.columnWidthBlock = { [weak self] (column) -> (Double) in
                var width = 0.0
                if let block = self?.columnWidthBlock {
                    width = block(column)
                }
                return width
            }
            sub.touchedBlock = { [weak self] (item) -> (Void) in
                self?.parent?.reloadChildren()
                if let block = self?.touchedBlock {
                    block(item)
                }
            }
        }
    }
}
