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

class TimelineViewController: UIViewController {

    @IBOutlet weak var timelineTableView: UITableView!

    var accountStore = ACAccountStore()
    var twitterAccount: ACAccount?

    override func viewDidLoad() {
        super.viewDidLoad()
        selectTwitterAccount()
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
            }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

}

extension TimelineViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
