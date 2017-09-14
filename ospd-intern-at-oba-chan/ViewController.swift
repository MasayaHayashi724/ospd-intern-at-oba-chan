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

    private let host = "https://atobachan-team2ospd.c9users.io"
    
    @IBOutlet weak var youngScreenName: UITextField!
    @IBOutlet weak var twitterID: UITextField!
    @IBOutlet weak var phoneNum: UITextField!

    var twitterConnectionUrl: URL? {
        didSet {
            DispatchQueue.main.async {
                self.moveToTwitterConnectionVC(url: self.twitterConnectionUrl!)
            }
        }
    }
    
    @IBAction func coopTwitter(_ sender: UIButton) {
        postInfoToDB()
        getUrlForConnectingTwitter()
    }

    private func postInfoToDB() {
        guard let oldScreenName = twitterID.text else { return }
        guard let youngScreenName = youngScreenName.text else { return }
        guard let email = phoneNum.text else { return }
        guard !oldScreenName.isEmpty && !youngScreenName.isEmpty && !email.isEmpty else { return }
        let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: "\(host)/api/users?old_screen_name=\(oldScreenName)&young_screen_name=\(youngScreenName)&email=\(encodedEmail!)")!
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
            guard let url = json["response"].url else { return }
            self.twitterConnectionUrl = url
        }.resume()
    }

    private func moveToTwitterConnectionVC(url: URL) {
        guard let oldScreenName = twitterID.text else { return }
        guard let youngScreenName = youngScreenName.text else { return }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TwitterConnection") as! TwitterConnectionViewController
        vc.twitterConnectionUrl = url
        vc.oldScreenName = oldScreenName
        vc.youngScreenName = youngScreenName
        self.present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

