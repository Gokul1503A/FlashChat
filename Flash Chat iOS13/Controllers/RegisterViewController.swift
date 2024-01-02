//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var errorlabel: UILabel!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text{
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e)
                    self.errorlabel.text = e.localizedDescription
                }
                else {
                    //navigate to next screen
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                    self.errorlabel.isHidden = true
                }
            }

        }
        else{
            errorlabel.text = "enter valid email and password"
        }
    }
    
}
