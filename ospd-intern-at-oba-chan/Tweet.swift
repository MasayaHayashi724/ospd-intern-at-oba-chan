//
//  Tweet.swift
//  ospd-intern-at-oba-chan
//
//  Created by Masaya Hayashi on 2017/09/13.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import Foundation

class Tweet {
    let userName: String
    let iconImageUrl: URL
    let imageUrl: URL

    init(userName: String, iconImageUrlString: String, imageUrlString: String) {
        self.userName = userName
        self.iconImageUrl = URL(string: iconImageUrlString)!
        self.imageUrl = URL(string: imageUrlString)!
    }
}
