//
//  RegistrationViewController.swift
//  Chat
//
//  Created by Даир Алаев on 03.05.2021.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.cornerRadius = 4
        registerButton.layer.masksToBounds = true
    
    }
    

    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error!)
            } else {
                self.performSegue(withIdentifier: "goToChatFromRegistration", sender: nil)
            }
        }
    }
}
