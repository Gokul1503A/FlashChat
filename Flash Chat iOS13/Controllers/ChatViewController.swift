//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages = [Message]()
       
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.dataSource = self
        
        loadMessages()

    }
    
    func loadMessages(){
        
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { QuerySnapshot, error in
            
            self.messages = []
            
            if let e = error{
                print(e)
                
            }
            else{
                if let snapDocuments = QuerySnapshot?.documents{
                    for doc in snapDocuments{
                        let data = doc.data()
                        if let MessageSender = data[K.FStore.senderField], let MessageBody = data[K.FStore.bodyField]{
                            let newMessage = Message(sender: MessageSender as! String, body: MessageBody as! String)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if  let messageBody = messageTextfield.text,  let messageSender = Auth.auth().currentUser?.email {
            
            
            
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField : messageSender, K.FStore.bodyField : messageBody, K.FStore.dateField : Date().timeIntervalSince1970]) { error in
                if let e = error {
                    print(e)
                }
                else{
                    print("success")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print(error)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        if message.sender == Auth.auth().currentUser?.email{
            cell.imageAvatar.isHidden = false
            cell.leftImageAvatar.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.messageLabel.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        else {
            cell.imageAvatar.isHidden = true
            cell.leftImageAvatar.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.messageLabel.textColor = UIColor(named: K.BrandColors.purple)
        }
        cell.messageLabel.text = message.body
        return cell
        
    }
    
    
}
