//
//  ViewController.swift
//  ospd-intern-at-oba-chan
//
//  Created by Masaya Hayashi on 2017/09/12.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var myID: UITextField!
    @IBOutlet weak var makeID: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var groupName: UITextField!
    
    @IBAction func coopTwitter(_ sender: UIButton) {
        if myID.text != "" && makeID.text != "" && phoneNum.text != "" && groupName.text != ""{
            let myID = self.myID.text!
            let makeID  = self.makeID.text!
            let phoneNum = self.phoneNum.text!
            let groupName = self.groupName.text!
            
            // 接続先のURLにパラメータを追加
            let stringUrl = "http://localhost:3000/test/?myID=\(myID)&makeID=\(makeID)&phoneNum=\(phoneNum)&groupName=\(groupName)"
            
            // 文字列のURLからNSURLに変換
            let URL = NSURL(string:stringUrl)!
            // NSURLを引数にRequestの生成
            //let req = URLRequest(url: URL! as URL)
            
            // ここからが実際に通信をする所（非同期通信）
//            let task = URLSession.shared.dataTask(with: req, completionHandler: {
//                (data, res, err) in
            
            let task = URLSession.shared.dataTask(with: URL as URL, completionHandler: {data, response, error in
//                // サーバから出力はありますか？
             if data != nil {
//                    // あるみたいだから文字列に変換しておく
                    let text = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(text!)
//                    // 非同期通信内でUIに変更を加えるときのおまじないと思って！
//                    DispatchQueue.main.async(execute: {
//                        self.resultLabel.text = text as String?
//                    })
//                }else{
//                    // サーバから返事がないみたいだからエラー表示
//                    DispatchQueue.main.asyncdispatch_async(DispatchQueue.main,execute: {
//                        self.resultLabel.text = "ERROR"
//                    })
                }
            })
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

