//
//  ChatViewController.swift
//  Chat
//
//  Created by Даир Алаев on 03.05.2021.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var attachFileButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputContainerHeightConstraint: NSLayoutConstraint!
    
    private let messagesDB = Database.database().reference().child("Messages")
    private var messages: [Any] = []

    
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextField.delegate = self
        
        let tapOnTableView = UITapGestureRecognizer(target: self, action: #selector(tappedOnTableView))
        tableView.addGestureRecognizer(tapOnTableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MessageCell.id, bundle: Bundle(for: MessageCell.self)), forCellReuseIdentifier: MessageCell.id)
        tableView.register(UINib(nibName: ImageMessageCell.id, bundle: Bundle(for: ImageMessageCell.self)), forCellReuseIdentifier: ImageMessageCell.id)
        tableView.separatorStyle = .none
        fetchFromFirebase()
    }
    
    @IBAction func attachFileButtonPressed(_ sender: Any) {
        attachImage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        
        storage.child("Images/\(messages.count).png").putData(imageData, metadata: nil) { (_, error) in
            if error != nil {
                print("Failed to upload image, \(error!)")
            } else {
                self.storage.child("Images/\(self.messages.count).png").downloadURL { (url, error) in
                    if error != nil {
                        print("Failed to get image URL, \(error!)")
                    } else {
                        let urlString = url?.absoluteString
                        print(urlString!)
                        guard let email = Auth.auth().currentUser?.email else { return }
                        
                        let messageDict = ["sender": email, "message": "", "image": urlString]
                                                
                        self.messagesDB.childByAutoId().setValue(messageDict) {(error, reference) in
                            if error != nil {
                                print("Failed to send a message, \(error!)")
                            }
                        }
                    }
                }
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        sendToFirebase()
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let error{
            print("Failed to Sign Out, \(error)")
        }
    }
    
    @objc func tappedOnTableView() {
        inputTextField.endEditing(true)
    }
    
    
}
extension ChatViewController {
    private func attachImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

extension ChatViewController {
    private func sendToFirebase() {
        guard let message = inputTextField.text else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        
        let messageDict = ["sender": email, "message": message, "image": ""]
        
        inputTextField.text = ""
        sendButton.isEnabled = false
        
        messagesDB.childByAutoId().setValue(messageDict) { [weak self] (error, reference) in
            if error != nil {
                print("Failed to send a message, \(error!)")
            } else {
                self?.sendButton.isEnabled = true
            }
        }
    }
    
    private func fetchFromFirebase() {
        messagesDB.observe(.childAdded) { [weak self] (snapshot) in
            if let value = snapshot.value as? [String: String] {
                guard let sender = value["sender"] else { return }
                guard let message = value["message"] else { return }
                guard let image = value["image"] else { return }
                
                if message != "" {
                    self?.messages.append(MessageEntity(sender: sender, message: message))
                } else {
                    self?.messages.append(ImageMessageEntity(sender: sender, imageURL: image))
                }
                self?.tableView.reloadData()
                self?.scrollToLastMessage()

            }
        }

    }
    
    private func scrollToLastMessage() {
        if messages.count > 1 {
            let indexPath = IndexPath(row: messages.count-1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.inputContainerHeightConstraint.constant = 50 + 300
            self.view.layoutIfNeeded()
        }
        scrollToLastMessage()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4) {
            self.inputContainerHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        scrollToLastMessage()
    }
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if messages[indexPath.row] is MessageEntity {
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.id, for: indexPath) as! MessageCell
            cell.message = message as? MessageEntity
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageMessageCell.id, for: indexPath) as! ImageMessageCell
            cell.message = message as? ImageMessageEntity
            return cell
        }
    }
}
