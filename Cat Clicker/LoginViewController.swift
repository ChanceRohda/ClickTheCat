//
//  LoginViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 8/6/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class LoginViewController: UIViewController {
    @IBOutlet weak var eyeButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    @IBAction func loginButtonDidTouch(_ sender: Any) {
        guard let username = usernameTextField.text?.lowercased() else {return}
        let email = username + "@gmail.com"
        guard let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                
                
                var errorTitle = "There was a problem."
                var errorMessage = "We could not log you in."
                
                if let errCode = AuthErrorCode.Code(rawValue: error._code) {
                    switch errCode {
                    case .wrongPassword:
                        errorTitle = "Wrong Password"
                        errorMessage = "Your password is incorrect"
                    case .invalidEmail:
                        errorTitle = "Invalid Username"
                        errorMessage = "The username you provided is invalid"
                    default:
                        break
                    }
                }
                
                let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { action in
                    alert.dismiss(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true)
                return
            }
            DispatchQueue.main.async {
                RootManager.login()
            }
        }
    }
    @IBAction func eyeButtonDidTouch(_ sender: Any) {
        if passwordTextField.isSecureTextEntry == true {
        passwordTextField.isSecureTextEntry = false
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }


}
