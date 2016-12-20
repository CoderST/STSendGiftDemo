//
//  STTtrajectory.swift
//  STSendGiftView
//
//  Created by xiudou on 2016/12/20.
//  Copyright © 2016年 CoderST. All rights reserved.
//  弹道View

import UIKit
import SnapKit
/// 动画执行时间
private let duration : NSTimeInterval = 0.25
/// 延时时间
private let afterDelay : NSTimeInterval = 3
/// 发送头像大小
private let sendUserIconImageViewSize : CGFloat = 30
/// 发送名称字体大小
private let sendUserNameLabelFontSize : CGFloat = 14
/// 礼物图片大小
private let giftIconImageViewSize : CGFloat = 30
/// 礼物名称字体大小
private let giftNameLabelFontSize : CGFloat = 14

enum STTrajectoryViewState {
    /// 闲置
    case idle
    /// 正在执行动画
    case animating
    /// 等待时间(默认3秒)
    case willEnd
    /// 正在消失动画
    case endAnimating
}


protocol STTrajectoryViewDelegate : class {
    /// 弹道动画结束时候的代理方法
    func endAnimation(trajectoryView : STTrajectoryView)
}

class STTrajectoryView: UIView {

    /// 发送头像
    private lazy var sendUserIconImageView : UIImageView = UIImageView()
    /// 发送名称
    private lazy var sendUserNameLabel : UILabel = UILabel()
    /// 礼物名称
    private lazy var giftNameLabel : UILabel = UILabel()
    /// 礼物图片
    private lazy var giftIconImageView : UIImageView = UIImageView()
    /// 弹动label
    private lazy var beatLabel : STBeatLabel = STBeatLabel()
    
    var state : STTrajectoryViewState = .idle
    weak var delegate : STTrajectoryViewDelegate?
    
    // 用于STBeatLabel显示的数字
    private var currentNumber : Int = 0
    // 缓存的数字
    private var cacheNumber : Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置UI界面
        setupUI()
    }
    
    var giftInforModel : STGiftInforModel?{
        
        didSet{
            guard let giftInforModel = giftInforModel else { return }
            sendUserIconImageView.image = UIImage(named: giftInforModel.senderURL ?? "")
            sendUserNameLabel.text = giftInforModel.senderName
            giftNameLabel.text = giftInforModel.giftName ?? ""
            giftIconImageView.image = UIImage(named: giftInforModel.giftURL ?? "")
            
            // 3.将ChanelView弹出
            state = .animating
            performAnimation()

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- 暴露函数
extension STTrajectoryView {
    
    func addOneToCache() {
        // 如果这个时候是等待3秒状态,可以直接执行label动画
        if state == .willEnd {
            performBeatLabelAnimation()
            // 取消等待3秒的时间
            NSObject.cancelPreviousPerformRequestsWithTarget(self)
        }else{
            
            cacheNumber += 1
        }
        
        
    }
}

// MARK:- 动画相关
extension STTrajectoryView {
    // 1 执行动画 弹道进入
    private func performAnimation() {
        beatLabel.alpha = 1.0
        beatLabel.text = " x1 "
        UIView.animateWithDuration(duration, animations: { 
            self.alpha = 1.0
            self.frame.origin.x = 0
            }) { (isFinished) in
                self.performBeatLabelAnimation()
        }


    }
    
    // 2 执行STBeatLabel动画
    private func performBeatLabelAnimation() {
        currentNumber += 1
        beatLabel.text = " x\(currentNumber) "
        beatLabel.addOneNumber {
            // 如果缓存数字存在,则一直执行label动画
            if self.cacheNumber > 0 {
                self.cacheNumber -= 1
                self.performBeatLabelAnimation()
            }else{
                // 缓存数字不存在(没有连击动画,则执行消失动画)
                self.state = .willEnd
                self.performSelector(#selector(self.performEndAnimation), withObject: self, afterDelay: afterDelay)
            }
            
        }
    }
    
    // 3 动画结束 弹道出去
    @objc private func performEndAnimation() {
        state = .endAnimating
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0
            self.frame.origin.x = UIScreen.mainScreen().bounds.size.width
        }) { (isFinished) in
            self.giftInforModel = nil  // 赋值后要在didSet守护一下 不然会死循环
            self.cacheNumber = 0
            self.currentNumber = 0
            self.beatLabel.alpha = 0
            self.beatLabel.text = "  "
            self.frame.origin.x = -self.frame.width
            self.state = .idle
            
            // 完成回调
            self.delegate?.endAnimation(self)

        }

    }
}
// MARK:- UI相关
extension STTrajectoryView {
    
    private func setupUI() {
        
        addSubview(sendUserIconImageView)
        addSubview(sendUserNameLabel)
        addSubview(giftNameLabel)
        addSubview(giftIconImageView)
        addSubview(beatLabel)
        
        sendUserIconImageView.contentMode = .ScaleAspectFit
        giftIconImageView.contentMode = .ScaleAspectFit
        
        sendUserNameLabel.font = UIFont.systemFontOfSize(sendUserNameLabelFontSize)
        giftNameLabel.font = UIFont.systemFontOfSize(giftNameLabelFontSize)
        
        sendUserIconImageView.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
            make.width.height.equalTo(sendUserIconImageViewSize)
        }
        
        sendUserNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(sendUserIconImageView.snp_right).offset(5)
            make.centerY.equalTo(self)
        }
        
        
        giftNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(sendUserNameLabel.snp_right).offset(5)
            make.centerY.equalTo(self)
        }

        giftIconImageView.snp_makeConstraints { (make) in
            make.left.equalTo(giftNameLabel.snp_right).offset(5)
            make.width.height.equalTo(giftIconImageViewSize)
            make.centerY.equalTo(self)
        }
        
        beatLabel.snp_makeConstraints { (make) in
            make.left.equalTo(giftIconImageView.snp_right).offset(5)
            make.centerY.equalTo(self)
        }
        

    }
}
