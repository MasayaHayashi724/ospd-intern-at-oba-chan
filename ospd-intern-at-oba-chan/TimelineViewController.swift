//
//  TimelineViewController.swift
//  ospd-intern-at-oba-chan
//
//  Created by Masaya Hayashi on 2017/09/12.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit
import Social
import Accounts
import SwiftyJSON

class TimelineViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var timelineTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var accountStore = ACAccountStore()
    var twitterAccount: ACAccount?
    var tweets = [Tweet]()

    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTwitterAccount()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getTimeline), for: .valueChanged)
        timelineTableView.addSubview(refreshControl)
        activityIndicator.hidesWhenStopped = true
    }
    
    private func selectTwitterAccount() {
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (granted, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard granted else {
                print("error! Twitterアカウントの利用が許可されていません")
                return
            }
            
            let accounts = self.accountStore.accounts(with: accountType) as! [ACAccount]
            if accounts.isEmpty {
                print("error! 設定画面からアカウントを設定してください")
                return
            }
            
            self.showAccountSelectSheet(accounts: accounts)
        }
    }
    
    private func showAccountSelectSheet(accounts: [ACAccount]) {
        let alert = UIAlertController(title: "Twitter", message: "アカウントを選択してください", preferredStyle: .actionSheet)
        
        for account in accounts {
            alert.addAction(UIAlertAction(title: account.username, style: .default, handler: { _ in
                self.twitterAccount = account
                self.getTimeline()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getTimeline() {
        let url = URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")!
        
        guard let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: nil) else { return }
        
        request.account = twitterAccount
        
        request.perform { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else { return }
            let tweets = JSON(data: data)
            var tweetsWithPicture = [Tweet]()
            for tweet in tweets.array! {
                guard let userName = tweet["user"]["name"].string else { continue }
                guard let profileImageUrl = tweet["user"]["profile_image_url"].string else { continue }
                guard let mediaUrl = tweet["entities"]["media"][0]["media_url"].string else { continue }
                let tw = Tweet(userName: userName, iconImageUrlString: profileImageUrl, imageUrlString: mediaUrl)
                tweetsWithPicture.append(tw)
            }
            self.tweets = tweetsWithPicture
            DispatchQueue.main.async {
                self.timelineTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        let sourceType = UIImagePickerControllerSourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    //撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            postTweet(data: pickedImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    private func postTweet(data: UIImage) {
        activityIndicator.startAnimating()
        let url = URL(string: "https://upload.twitter.com/1.1/media/upload.json")!
        guard let imageData = UIImageJPEGRepresentation(data, 0.5) else { return }

        guard let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: url, parameters: nil) else { return }
        request.account = twitterAccount
        request.addMultipartData(imageData, withName: "media", type: "image/jpeg", filename: "image.jpeg")

        request.perform { (data, response, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            guard let data = data else { return }
            let json = JSON(data: data)
            guard let mediaIdString = json["media_id_string"].string else { return }
            self.postMediaToTwitter(mediaIdString: mediaIdString)
        }
    }

    func postMediaToTwitter(mediaIdString: String) {
        let url = URL(string: "https://api.twitter.com/1.1/statuses/update.json")!
        let parameters = ["media_ids": mediaIdString]
        guard let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: url, parameters: parameters) else { return }
        request.account = twitterAccount

        request.perform { (data, res, err) in
            if let err = err {
                print(err)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            guard let data = data else { return }
            print(data)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            self.getTimeline()
        }
    }

}

extension TimelineViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timelineTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TweetTableViewCell
        let tweet = tweets[indexPath.row]
        cell.configure(tweet: tweet)
        cell.selectionStyle = .none
        return cell
    }

}
