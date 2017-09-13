//
//  WebViewController.swift
//  ospd-intern-at-oba-chan
//
//  Created by Masaya Hayashi on 2017/09/13.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = url else { return }
        let req = URLRequest(url: url)
        webView.loadRequest(req)
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Timeline", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! TimelineViewController
        self.present(vc, animated: true, completion: nil)
    }

}
