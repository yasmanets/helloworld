//
//  SplashViewController.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var titleLabel:      UILabel!
    @IBOutlet weak var subtitleLabel:   UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLabels()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigateToUsersList()
        }
    }
    
    private func setupLabels() {
        self.titleLabel.text = R.string.localizable.splash_title_label()
        self.subtitleLabel.text = R.string.localizable.splash_subtitle_label()
    }
    
    private func navigateToUsersList() {
        self.performSegue(withIdentifier: R.segue.splashViewController.usersSegue, sender: nil)
    }

}
