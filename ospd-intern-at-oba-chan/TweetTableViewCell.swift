//
//  TweetTableViewCell.swift
//  ospd-intern-at-oba-chan
//
//  Created by Masaya Hayashi on 2017/09/12.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!

    func configure(tweet: Tweet) {
        iconImageView.load(from: tweet.iconImageUrl)
        userNameLabel.text = tweet.userName
        pictureImageView.load(from: tweet.imageUrl)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
