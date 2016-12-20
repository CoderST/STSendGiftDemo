//
//  ViewController.swift
//  STSendGiftDemo
//
//  Created by xiudou on 2016/12/20.
//  Copyright © 2016年 CoderST. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// 展示的view
    private lazy var sendGiftView : STSendGiftView = STSendGiftView()
    
    private lazy var senderNameArray : [String] = ["ST","HJJ","CODER","HELLOW"]
    private lazy var senderNameIconArray : [String] = ["icon1","icon2","icon3","icon4"]
    
    private lazy var giftNameArray : [String] = ["火箭","跑车","啤酒","蘑菇"]
    private lazy var giftNameIconArray : [String] = ["qiche","yuanbao","huanggua","feiji"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(sendGiftView)
        sendGiftView.backgroundColor = UIColor.grayColor()
        sendGiftView.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 200)

    }

    

    @IBAction func sendGiftClick(sender: AnyObject) {
        let senderName = senderNameArray[Int(arc4random_uniform(4))]
        let senderURL = senderNameIconArray[Int(arc4random_uniform(4))]
        let giftName = giftNameArray[Int(arc4random_uniform(4))]
        let giftURL = giftNameIconArray[Int(arc4random_uniform(4))]
        
        let gift1 = STGiftInforModel(senderName: senderName, senderURL: senderURL, giftName: giftName, giftURL: giftURL)
        sendGiftView.showGiftModel(gift1)

        
    }

}

