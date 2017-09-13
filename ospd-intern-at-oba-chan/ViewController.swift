//
//  ViewController.swift
//  ospd-intern-at-oba-chan
//
//  Created by Masaya Hayashi on 2017/09/12.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    private let host = "http://localhost:3000"
    
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
        let url = URL(string: "\(host)/api/users?screen_name=\(screenName)&email=\(email)")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        URLSession.shared.dataTask(with: req) { (data, res, err) in
            if let err = err {
                print(err)
                return
            }
            guard let data = data else { return }
            print(data)
        }.resume()
    }

    private func getUrlForConnectingTwitter() {
        let url = URL(string: "\(host)/api/twitter")!
        let req = URLRequest(url: url)
        URLSession.shared.dataTask(with: req) { (data, res, err) in
            if let err = err {
                print(err)
                return
            }
            guard let data = data else { return }
            let json = JSON(data: data)
            guard let url = json["response"]["url"].url else { return }
            self.twitterConnectionUrl = url
        }.resume()
    }

    private func moveToTwitterConnectionVC(url: URL) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TwitterConnection") as! TwitterConnectionViewController
        vc.twitterConnectionUrl = url
        self.present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

