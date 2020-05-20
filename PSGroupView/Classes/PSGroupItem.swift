//
//  PSGroupItem.swift
//  PSGroupView
//
//  Created by shenwenxin on 2020/5/19.
//  Copyright © 2020 swx. All rights reserved.
//

import Foundation
import UIKit

/// 分组 item 协议
protocol PSGroupItem {
    /// 设置某一列宽度的回调
    typealias columnWidthBlock = (_ column: Int) -> (Float)
    /// 点击事件回调
    typealias touchedBlock = (_ obj: PSGroupItem?) -> (Void)
    /// 上一级 item
    var parent: PSGroupItem? { get set }
    /// 每一列的内容
    func textValues() -> [String?]
    /// 下级内容
    func items() -> [PSGroupItem?]
    /// 当前所处层级
    func digitalDepth() -> Int
    /// 获取视图
    func getView() -> UIView
    /// 刷新视图内容
    func reloadView()
    /// 刷新下级内容
    func reloadChildren()
    /// 切换展开/收起状态
    func switchExpend(expand: Bool)
    /// 是否是最底层 item
    func isBottomLevelItem() -> Bool
}

//func ==<T: PSGroupItem>(lhs: T, rhs: T) -> Bool {
//    return lhs.digitalDepth() == rhs.digitalDepth()
//}

// MARK: - 默认实现
extension PSGroupItem {
    
}
