//
//  ViewController.swift
//  ospd-intern-at-oba-chan
//
//  Created by Masaya Hayashi on 2017/09/12.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var twitterID: UITextField!
    @IBOutlet weak var phoneNum: UITextField!

    var twitterConnectionUrl: URL? {
        didSet {
            moveToTwitterConnectionVC(url: twitterConnectionUrl!)
        }
    }
    
    @IBAction func coopTwitter(_ sender: UIButton) {
        postInfoToDB()
        getUrlForConnectingTwitter()
    }

    private func postInfoToDB() {
        // TODO: twitterIDなどをDBに保存するAPIを叩く
    }

    private func getUrlForConnectingTwitter() {
        // TODO: Twitter連携用のURLを取得してurltwitterConnectionUrlに代入
    }

    private func moveToTwitterConnectionVC(url: URL) {
        // TODO: Twitter連携するためのVCにurlを渡して遷移する
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

