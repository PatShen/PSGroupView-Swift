//
//  PSGroupView.swift
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/20.
//  Copyright © 2020 swx. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 设置某一列的宽度回调
typealias columnWidthClosure = (_ column: Int) -> (Double)
/// 加载数据的回调
typealias loadDataClosure = () -> (PSGroupItem?)
/// 点击事件回调
typealias touchedClosure = () -> (Void)

/// 嵌套视图
class PSGroupView: UIView, UITableViewDataSource, UITableViewDelegate {
    // MARK: Public
    /// 设置某一列的宽度回调
    var loadDataBlock: (()->(PSGroupItem?))?
//    var loadDataBlock: loadDataClosure?
    /// 设置某一列的宽度回调
    var columnWidthBlock: ((_ column:Int) -> (Double))?
    /// 点击事件回调
    var touchedBlock: ((_ obj:PSGroupItem?)->(Void))?
    
    /// 是否为展开状态
    fileprivate (set) var isExpand : Bool?
    
    func reloadData() -> Void {
        let item = loadDataBlock?()
        self.item = item
        self.composeLabels()
        self.composeLine()
        self.composeTableView()
    }
    
    func reloadChildren() -> Void {
        guard let tbl = self.tblList else { return }
        if (self.item?.items()?.count)! > 0 {
            if self.isExpand! {
                // 这行代码为了解决 content size 计算不准确的问题
//                tbl.snp.updateConstraints { (make) in
//                    make.height.equalTo(UIScreen.main.bounds.size.height)
//                }
//                tbl.layoutIfNeeded()
                tbl.isHidden = false
                tbl.reloadData()
                tbl.layoutIfNeeded()
                let size = tbl.contentSize
//                tbl.snp.updateConstraints { (make) in
//                    make.height.equalTo(size.height)
//                }
                tbl.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.viewContent.snp.bottom);
                    make.leading.trailing.equalToSuperview();
                    make.bottom.equalToSuperview();
                    make.height.equalTo(size.height)
                }
            }
            else {
                tbl.isHidden = true
                tbl.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            }
        }
        else {
            tbl.isHidden = true
            tbl.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
    }
    
    func switchExpand(_ isExpand: Bool) -> Void {
        guard let items = self.item?.items() else { return }
        if items.count <= 0 {
            return
        }
        self.isExpand = !self.isExpand!
        self.reloadChildren()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.defaultConfig()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.defaultConfig()
    }
    
    deinit {
        
    }
    
    // MARK: Private
    /// 行高
    fileprivate var rowHeight: Double?
    /// 字号
    fileprivate var textFont: UIFont?
    /// 字色
    fileprivate var textColor: UIColor?
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate var viewLine: UIView?
    fileprivate var tblList: UITableView?
    
    fileprivate weak var item: PSGroupItem?
    fileprivate var labelsArray: [UILabel]?
    
    fileprivate func defaultConfig() {
        self.isExpand = false
        self.rowHeight = 40.0
        self.textFont = UIFont.systemFont(ofSize: 14.0);
        self.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        self.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).priority(.high)
        }
    }
    
    fileprivate func createLabel() -> UILabel! {
        let lbl = UILabel.init()
        lbl.backgroundColor = .clear
        lbl.font = self.textFont
        lbl.textColor = self.textColor
        lbl.textAlignment = .center
        return lbl
    }
    
    fileprivate func composeLabels() -> Void {
        guard let model = self.item else { return }
        self.labelsArray?.forEach({ (label) in
            label.removeFromSuperview()
        })
        guard let values = model.textValues() else { return }
        var lastView: UILabel?
        for e in values.enumerated().reversed() {
            let idx = e.offset
            let text = e.element
            let label: UILabel! = self.createLabel()
            label.text = text
            let superview = self.viewContent
            superview.addSubview(label)
            let firstItemOffset = 14.0
            let firstItemOrigin = 20.0
            let depth = model.digitalDepth()
            var leadingOffset = 0.0
            if depth != 0 && idx == 0 {
                label.textAlignment = .left
                if model.isBottomLevelItem() && depth > 0 {
                    leadingOffset = firstItemOrigin + firstItemOffset*Double((depth-1))
                }
                else {
                    leadingOffset = firstItemOrigin+firstItemOffset*Double(depth)
                }
            }
            label.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                if idx == 0 {
                    if let view = lastView {
                        make.trailing.equalTo(view.snp.leading)
                    }
                    if depth == 0 {
                        make.height.equalTo(self.rowHeight!)
                        make.leading.equalToSuperview()
                    }
                    else {
                        make.leading.equalToSuperview().offset(leadingOffset)
                    }
                }
                else {
                    let width = self.columnWidthBlock?(idx)
                    make.size.equalTo(CGSize.init(width: width!, height: self.rowHeight!))
                    guard let view = lastView else {
                        make.trailing.equalToSuperview();
                        return
                    }
                    make.trailing.equalTo(view.snp.leading)
                }
            }
            lastView = label
        }
    }
    
    fileprivate func createLineView() -> Void {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
        self.viewContent.addSubview(view)
        self.viewLine = view
    }
    
    fileprivate func createTableView() -> Void {
        let size = CGSize.init(width: UIScreen.main.bounds.size.width, height: 20.0)
        let rect = CGRect.init(origin: CGPoint(), size: size)
        let tbl = UITableView.init(frame: rect, style: .plain)
        tbl.backgroundColor = .clear
        tbl.separatorStyle = .none
        tbl.dataSource = self
        tbl.delegate = self
        
        // iOS 11 之前的版本要加这一句，否则自动计算高度会无效
        if (Double(UIDevice.current.systemVersion)! < 11.0) {
            tbl.estimatedRowHeight = 50
        }
        self.addSubview(tbl)
        self.tblList = tbl
    }
    
    fileprivate func composeLine() -> Void {
        guard let view = self.viewLine else { return }
        view.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview();
            make.leading.trailing.equalToSuperview();
            make.height.equalTo(1.0/UIScreen.main.scale);
        }
    }
    fileprivate func composeTableView() -> Void {
        guard let view = self.tblList else { return }
        view.snp.makeConstraints { (make) in
            make.top.equalTo(self.viewContent.snp.bottom);
            make.leading.trailing.equalToSuperview();
            make.bottom.equalToSuperview();
            make.height.equalTo(0);
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.item?.items()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "items";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
            cell?.selectionStyle = .none
            cell?.contentView.backgroundColor = .clear
            cell?.backgroundColor = .clear
        }
        let obj: PSGroupItem? = self.item?.items()?[indexPath.row]
        guard let model = obj else { return cell! }
        let view = model.getView()
        if !(cell?.contentView.subviews.contains(view))! {
            let superview = cell?.contentView
            superview?.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.top.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().priority(.high)
            }
            model.reloadView()
        }
        return cell!
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension PSGroupView {
    class func viewForHeader() -> PSGroupView {
        let view = PSGroupView()
        view.textFont = .boldSystemFont(ofSize: 14.0)
        view.textColor = .black
        view.viewContent.backgroundColor = .white
        view.createLineView()
        view.createTableView()
        return view
    }
    
    class func viewForDepartment() -> PSGroupView {
        let view = PSGroupView()
        view.textFont = .systemFont(ofSize: 14.0)
        view.textColor = .gray
        view.viewContent.backgroundColor = .white
        view.createLineView()
        view.createTableView()
        return view
    }
    
    class func viewForMember() -> PSGroupView {
        let view = PSGroupView()
        view.textFont = .systemFont(ofSize: 12.0)
        view.textColor = .black
        view.viewContent.backgroundColor = .lightGray
        return view
    }
}
