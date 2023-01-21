//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let messages:[Message] = [
        Message(sender: "1@2.com", body: "What is up?"),
        Message(sender: "2@2.com", body: "Not much"),
        Message(sender: "1@2.com", body: "cool"),
    ]
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].body
        return cell
    }
    
    
}

//MARK: - override statedidchangeListener
extension ChatViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                if let email = user.email {
                    self.title = email
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            if let email = user.email {
                print("viewWillDissapear State changed to \(email)")
            }
        }
        Auth.auth().removeStateDidChangeListener(handle!)
    }
}
