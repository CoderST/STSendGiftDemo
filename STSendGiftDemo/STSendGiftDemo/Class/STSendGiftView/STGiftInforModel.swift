//
//  STUserInfor.swift
//  STSendGiftView
//
//  Created by xiudou on 2016/12/20.
//  Copyright © 2016年 CoderST. All rights reserved.
//

import UIKit

class STGiftInforModel: NSObject {

    /// 发送者名称
    var senderName : String = ""
    /// 发送者头像URL
    var senderURL : String = ""
    /// 礼物名称
    var giftName : String = ""
    /// 礼物图片URL
    var giftURL : String = ""
    
    // 构造函数
    init(senderName : String, senderURL : String, giftName : String, giftURL : String) {
        
        self.senderName = senderName
        self.senderURL = senderURL
        self.giftName = giftName
        self.giftURL = giftURL
    }
    
    // 重写父类
    override func isEqual(object: AnyObject?) -> Bool {
        
        guard let model = object as? STGiftInforModel else { return false}
        
        guard  model.senderName == senderName && model.giftName == giftName else{
            
            return false
        }
        
        return true
        
    }

}
