//
//  SignUpViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 8/6/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SignUpViewController: UIViewController {

    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
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
    

    @IBAction func createAccountButtonDidTouch(_ sender: Any) {
        guard let username = usernameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                var errorTitle = "There was a problem"
                var errorMessage = "We could not sign you up"
                if let errCode = AuthErrorCode.Code(rawValue: error._code) {
                    switch errCode {
                    case .emailAlreadyInUse:
                        errorTitle = "Email In Use"
                        errorMessage = "The email you provided is already in use"
                    case .missingEmail:
                        errorTitle = "Email Is Required"
                        errorMessage = "Enter an email"
                    case .weakPassword:
                        errorTitle = "Weak Password"
                        errorMessage = "Please improve your password strength"
                    case .invalidEmail:
                        errorTitle = "Email is Invalid"
                        errorMessage = "Please enter a valid email"
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
            let ref = Database.database().reference()
            let userRef = ref.child("users")
            guard let refKey = Auth.auth().currentUser?.uid else {return}
            let userValue = ["username": username, "uid": result!.user.uid, "email": email]
            userRef.updateChildValues([refKey: userValue])
            //DispatchQueue.main.async {
            //    RootManager.login()
            //}
            self.performSegue(withIdentifier: "tutorialSegue", sender: nil)
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
