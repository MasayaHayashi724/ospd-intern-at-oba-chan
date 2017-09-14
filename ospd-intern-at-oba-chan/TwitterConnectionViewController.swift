//
//  TwitterConnectionViewController.swift
//  ospd-intern-at-oba-chan
//
//  Created by Masaya Hayashi on 2017/09/13.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

class TwitterConnectionViewController: UIViewController {

    var twitterConnectionUrl: URL?
    var oldScreenName: String?
    var youngScreenName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func twitterConnectionButtonTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Web") as! WebViewController
        vc.url = twitterConnectionUrl
        vc.oldScreenName = oldScreenName
        vc.youngScreenName = youngScreenName
        self.present(vc, animated: true, completion: nil)
    }

}
