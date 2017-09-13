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
        guard let screenName = twitterID.text else { return }
        guard let email = phoneNum.text else { return }
        guard !screenName.isEmpty && !email.isEmpty else { return }
        let url = URL(string: "http://localhost:3000/api/users?screen_name=\(screenName)&email=\(email)")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        URLSession.shared.dataTask(with: req) { (data, res, err) in
            if let err = err {
                print(err)
                return
            }
            guard let data = data else { return }
            print(data)
        }
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

