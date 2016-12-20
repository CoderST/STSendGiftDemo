//
//  STBeatLabel.swift
//  STSendGiftView
//
//  Created by xiudou on 2016/12/19.
//  Copyright © 2016年 CoderST. All rights reserved.
//

import UIKit
private let duration : NSTimeInterval = 0.25
private let bigScale : CGFloat = 3.0
private let smallScale : CGFloat = 0.9
class STBeatLabel: UILabel {

   
    override func drawRect(rect: CGRect) {
        // 1 获取上下文
        let context = UIGraphicsGetCurrentContext()
        // 2 绘制空心部分
        CGContextSetLineWidth(context, 5)
        // 2.1 设置圆角
        CGContextSetLineJoin(context, .Round)
        // 2.2 设置空心
        CGContextSetTextDrawingMode(context, .Stroke)
        // 2.3 添加颜色
        textColor = UIColor.orangeColor()
        // 2.4 调用父类
        super.drawTextInRect(rect)
       
        // 3 绘制实心部分
        CGContextSetTextDrawingMode(context, .Fill)
        // 3.1 设置颜色
        textColor = UIColor.whiteColor()
        // 3.2 调用父类
        super.drawTextInRect(rect)

    }
}

// MARK:- 对外暴露的接口
extension STBeatLabel {
    
    func addOneNumber(completion : ()->()) {
        UIView.animateKeyframesWithDuration(duration, delay: 0, options: [], animations: { 

            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransformMakeScale(bigScale, bigScale)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransformMakeScale(smallScale, smallScale)
            })

            
            }) { (isFinished) in
                
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                    self.transform = CGAffineTransformIdentity
                    }, completion: { (isFinished) in
                        completion()
                })
        }
    }
}
