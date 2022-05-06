//
//  UsersViewController.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import UIKit

class UsersViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    
    private var users: [Users] = []
    
    private let userCellIdentifier    = "userCell"
    private let userTableViewCell     = "UsersTableViewCell"
    private let userCellHeight        = 80.0
    
    private var serverErrorSnackBar:    CustomSnackBar!
    private var successSnackBar:        CustomSnackBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationTitle()
        self.setupSnackBars()
        self.setupUsersTableView()
        self.getUsers()
    }

    private func setupNavigationTitle() {
        self.title = R.string.localizable.users_list_title()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddUser))
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupSnackBars() {
        self.serverErrorSnackBar = CustomSnackBar.createSnackbar(message: R.string.localizable.server_error_message(), type: .text, duration: .middle)
        self.successSnackBar = CustomSnackBar.createSnackbar(message: R.string.localizable.success_deletion_message(), type: .text, duration: .middle)
    }
    
    private func setupUsersTableView() {
        self.usersTableView.register(UINib(nibName: self.userTableViewCell, bundle: nil), forCellReuseIdentifier: self.userCellIdentifier)
        self.usersTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.usersTableView.dataSource     = self
        self.usersTableView.delegate       = self
    }
    
    private func getUsers() {
        let url = Constants.API_BASE_URL + Constants.USER_ENDPOINT
        ApiProvider().commonRequest(entity: [Users].self, url: url, method: .GET) { (data, error) in
            if let users = data {
                DispatchQueue.main.async {
                    self.users = users
                    self.usersTableView.reloadData()
                }
            }
            else if error == true {
                self.serverErrorSnackBar.showUp()
            }
        }
    }
    
    private func deleteUser(user: Users, indexPath: IndexPath) {
        let url = Constants.API_BASE_URL + Constants.USER_ENDPOINT + "/\(user.id!)"
        ApiProvider().commonRequest(entity: Users.self, url: url, method: .DELETE) { (data, error) in
            if data == nil && error == false {
                DispatchQueue.main.async {
                    self.users.remove(at: indexPath.row)
                    self.usersTableView.deleteRows(at: [indexPath], with: .fade)
                    self.successSnackBar.showUp()
                }
            }
            else {
                self.serverErrorSnackBar.showUp()
            }
        }
    }

    @objc func didTapAddUser() {
        self.navigateToManageUser(user: nil)
    }
    
    private func navigateToManageUser(user: Users?) {
        let viewController = UIStoryboard.init(name: "Manage", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManageViewController") as! ManageViewController
        viewController.user = user
        self.show(viewController, sender: self)
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.userCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.usersTableView.dequeueReusableCell(withIdentifier: self.userCellIdentifier, for: indexPath) as! UsersTableViewCell
        
        if let name = self.users[indexPath.row].name {
            cell.nameLabel.text = R.string.localizable.users_list_name(name)
        }
        else {
            cell.nameLabel.text = R.string.localizable.users_list_no_name()
        }
        
        
        let date = DateProvider().transformDate(from: Constants.FULLDATE, to: Constants.DATE, dateToConvert: self.users[indexPath.row].birthdate!)
        if let date = date {
            cell.birthdateLabel.text = R.string.localizable.users_list_birthdate(date)
        }
        else {
            cell.birthdateLabel.text = R.string.localizable.users_list_no_birthdate()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigateToManageUser(user: self.users[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteUser(user: self.users[indexPath.row], indexPath: indexPath)
        }
    }
}
