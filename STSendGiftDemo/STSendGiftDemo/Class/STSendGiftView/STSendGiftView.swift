//
//  STSendGiftView.swift
//  STSendGiftView
//
//  Created by xiudou on 2016/12/20.
//  Copyright © 2016年 CoderST. All rights reserved.
//

import UIKit

/// 弹道个数
private let trajectoryNumber : Int = 4
/// 弹道高度
private let trajectoryHeight : CGFloat = 40
/// 弹道间距
private let trajectoryMargin : CGFloat = 10
class STSendGiftView: UIView {

    
    /// 弹道数组
    private lazy var trajectoryArray : [STTrajectoryView] = [STTrajectoryView]()
    /// 礼物模型缓存
    private lazy var cacheGiftModels : [STGiftInforModel] = [STGiftInforModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// 添加数据,判断弹道状态
extension STSendGiftView {
    func showGiftModel (giftInforModel : STGiftInforModel){
        // 同一个用户,送得同一个礼物,并且弹道不是结束状态
        if let trajectoryView = checkTrajectoryView(giftInforModel){
            trajectoryView.addOneToCache()
            return
        }
        
        // 有闲置弹道,赋值数据,开始动画
        if let idleTrajectoryView = checkIdenTrajectoryView(){
            
            idleTrajectoryView.giftInforModel = giftInforModel
            
            return
        }
        
        // 其他情况
        cacheGiftModels.append(giftInforModel)
        
        
    }
    
    
    private func checkTrajectoryView(giftInforModel : STGiftInforModel)->STTrajectoryView?{
        
        for trajectoryView in trajectoryArray{
           
            if giftInforModel.isEqual(trajectoryView.giftInforModel) && trajectoryView.state != .endAnimating{
                
                return trajectoryView
            }
        }
        return nil
    }
    
    private func checkIdenTrajectoryView()->STTrajectoryView? {
        for trajectoryView in trajectoryArray {
            
            if trajectoryView.state == .idle{
                
                return trajectoryView
            }
        }
        
        return nil
    }
}

// MARK:- UI
extension STSendGiftView {
    
    private func setupUI() {
        let w : CGFloat = frame.size.width
        let x : CGFloat = -w
        let h : CGFloat = trajectoryHeight
        for index in 0..<trajectoryNumber {
            let y : CGFloat = CGFloat(index) * h + trajectoryMargin
            let tra = STTrajectoryView(frame: CGRect(x: x, y: y, width: w, height: h))
            addSubview(tra)
            tra.delegate = self
            trajectoryArray.append(tra)
        }
    }
}

extension STSendGiftView : STTrajectoryViewDelegate{
    // 完成了一次label动画展示
    func endAnimation(trajectoryView: STTrajectoryView) {
        
        // 1 判断数组中是否还有需要展示的数据
        guard cacheGiftModels.count != 0 else { return }
    
        // 2 取出第一个数据
        let giftInforModel = cacheGiftModels.first!
        
        // 3 删除数组中的数据
        cacheGiftModels.removeFirst()
        
        // 4 赋值数据,执行一系列动画
        trajectoryView.giftInforModel = giftInforModel
        
        // 5 将数组中剩下的和firstModel一样的对象放入STTrajectoryView缓存起来
        for index in (0..<cacheGiftModels.count).reverse(){
            let cacheModel = cacheGiftModels[index]
            if cacheModel.isEqual(giftInforModel){
                // 有一样的添加到缓存中进行+1操作
                trajectoryView.addOneToCache()
                cacheGiftModels.removeAtIndex(index)
            }
        }
        
    }
}
