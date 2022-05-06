//
//  ManageViewController.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import UIKit

class ManageViewController: UIViewController {

    @IBOutlet weak var imageContainer:  UIView!
    @IBOutlet weak var nameLabel:       UILabel!
    @IBOutlet weak var nameTextField:   UITextField!
    @IBOutlet weak var birthdateLabel:  UILabel!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    var user: Users?
    var type: String?
    
    private var serverErrorSnackBar:    CustomSnackBar!
    private var successSnackBar:        CustomSnackBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBar()
        self.setupSnackBars()
        self.setupImageContainer()
        self.setupLabels()
        self.setupNameTextField()
        self.setupDatePicker()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
        self.title = R.string.localizable.manage_user_title_view()
        if let type = type, type == "new" {
            self.title = R.string.localizable.manage_user_title_new()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveUser))
        }
    }
    
    private func setupSnackBars() {
        self.serverErrorSnackBar = CustomSnackBar.createSnackbar(message: R.string.localizable.server_error_message(), type: .text, duration: .middle)
        self.successSnackBar = CustomSnackBar.createSnackbar(message: R.string.localizable.successful_creation_message(), type: .text, duration: .middle)
    }
    
    private func setupImageContainer() {
        self.imageContainer.isHidden = true
        if let type = type, type == "view" {
            self.imageContainer.isHidden = false
        }
    }
    
    private func setupLabels() {
        self.nameLabel.text = R.string.localizable.manage_user_name()
        self.birthdateLabel.text = R.string.localizable.manage_user_birthdate()
    }
    
    private func setupNameTextField() {
        self.nameTextField.isUserInteractionEnabled = true
        if let type = type, type == "view" {
            self.nameTextField.text = self.user?.name
            self.nameTextField.isUserInteractionEnabled = false
        }
    }
    
    private func setupDatePicker() {
        self.birthDatePicker.isUserInteractionEnabled = true
        self.birthDatePicker.tintColor = .black
        if let type = type, let birthdate = self.user?.birthdate, type == "view" {
            if let formatedDate = DateProvider().transformDate(from: Constants.FULLDATE, to: Constants.DATE, dateToConvert: birthdate) {
                if let date = DateProvider().stringToDate(format: Constants.DATE, dateToConvert: formatedDate) {
                    self.birthDatePicker.date = date
                    self.birthDatePicker.isUserInteractionEnabled = false
                    self.birthDatePicker.tintColor = .lightGray
                }
            }
        }
    }
    
    @objc func didTapSaveUser() {
        let user = Users(id: 0, name: self.nameTextField.text, birthdate: "\(self.birthDatePicker.date)")
        let userDictionary = user.toDictionary()
        let url = Constants.API_BASE_URL + Constants.USER_ENDPOINT
        ApiProvider().commonRequest(entity: Users.self, url: url, method: .POST, body: userDictionary) { (data, error) in
            if data == nil && error == false {
                DispatchQueue.main.async {
                    self.successSnackBar.showUp()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                self.serverErrorSnackBar.showUp()
            }
        }
    }

}
