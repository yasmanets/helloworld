//
//  UsersViewController.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import UIKit

class UsersViewController: UIViewController {

    @IBOutlet weak var usersTableView:  UITableView!
    @IBOutlet weak var searchBar:       UISearchBar!
    
    private var users: [Users] = []
    private var filteredUsers: [Users] = []
    
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
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUsers()
    }

    private func setupNavigationTitle() {
        self.title = R.string.localizable.users_list_title()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddUser))
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupSnackBars() {
        self.serverErrorSnackBar = CustomSnackBar.createSnackbar(message: R.string.localizable.server_error_message(), type: .text, duration: .middle)
        self.successSnackBar = CustomSnackBar.createSnackbar(message: R.string.localizable.successful_deletion_message(), type: .text, duration: .middle)
    }
    
    private func setupUsersTableView() {
        self.usersTableView.register(UINib(nibName: self.userTableViewCell, bundle: nil), forCellReuseIdentifier: self.userCellIdentifier)
        self.usersTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.usersTableView.dataSource     = self
        self.usersTableView.delegate       = self
    }
    
    private func getUsers() {
        let url = Constants.API_BASE_URL + Constants.USER_ENDPOINT
        ApiProvider().commonRequest(entity: [Users].self, url: url, method: .GET, body: nil) { (data, error) in
            if let users = data {
                DispatchQueue.main.async {
                    self.users = users
                    self.users = users.sorted(by: { $0.birthdate!.compare($1.birthdate!) == .orderedDescending })
                    self.filteredUsers = self.users
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
        ApiProvider().commonRequest(entity: Users.self, url: url, method: .DELETE, body: nil) { (data, error) in
            if data == nil && error == false {
                DispatchQueue.main.async {
                    self.users.remove(at: indexPath.row)
                    self.filteredUsers.remove(at: indexPath.row)
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
        self.navigateToManageUser(user: nil, type: "new")
    }
    
    private func navigateToManageUser(user: Users?, type: String) {
        let viewController = UIStoryboard.init(name: "Manage", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManageViewController") as! ManageViewController
        viewController.user = user
        viewController.type = type
        self.show(viewController, sender: self)
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.userCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.usersTableView.dequeueReusableCell(withIdentifier: self.userCellIdentifier, for: indexPath) as! UsersTableViewCell
        
        if let name = self.filteredUsers[indexPath.row].name {
            cell.nameLabel.text = R.string.localizable.users_list_name(name)
        }
        else {
            cell.nameLabel.text = R.string.localizable.users_list_no_name()
        }
        
        
        let date = DateProvider().transformDate(from: Constants.FULLDATE, to: Constants.DATE, dateToConvert: self.filteredUsers[indexPath.row].birthdate!)
        if let date = date {
            cell.birthdateLabel.text = R.string.localizable.users_list_birthdate(date)
        }
        else {
            cell.birthdateLabel.text = R.string.localizable.users_list_no_birthdate()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigateToManageUser(user: self.filteredUsers[indexPath.row], type: "view")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteUser(user: self.filteredUsers[indexPath.row], indexPath: indexPath)
        }
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredUsers = []
        for user in self.users {
            if let name = user.name, name.contains(searchText) {
                self.filteredUsers.append(user)
            }
        }
        if self.filteredUsers.count == 0 {
            self.filteredUsers = self.users
        }
        self.usersTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredUsers = self.users
        self.usersTableView.reloadData()
    }
}
