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
protocol PSGroupItem : AnyObject {
    /// 设置某一列宽度的回调
    var columnWidthBlock : ((_ column: Int) -> (Double))? { get set }
    /// 点击事件回调
    var touchedBlock : ((_ obj: PSGroupItem?) -> (Void))? { get set }
    /**
     * 读取上一级 item
     *
     * ```
     * 实现时需要用 weak 修饰，否则会造成「循环引用」
     * ```
     */
    var parent: PSGroupItem? { get set }
    /// 每一列的内容
    func textValues() -> [String]?
    /// 下级内容
    func items() -> [PSGroupItem]?
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

// MARK: - 默认实现
extension PSGroupItem {
    
}
