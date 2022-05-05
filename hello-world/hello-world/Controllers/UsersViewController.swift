//
//  UsersViewController.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import UIKit

class UsersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationTitle()
    }
    

    private func setupNavigationTitle() {
        self.title = R.string.localizable.users_list_title()
    }

}
