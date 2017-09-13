//
//  UIImageView+Oba-chan.swift
//  ospd-intern-at-oba-chan
//
//  Created by Masaya Hayashi on 2017/09/13.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

extension UIImageView {

    func load(from url: URL, callback: @escaping () -> Void = {}) {
        let req = URLRequest(url: url)
        URLSession.shared.dataTask(with: req) { (data, res, err) in
            if let err = err {
                print(err)
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            callback()
            }.resume()
    }

}
