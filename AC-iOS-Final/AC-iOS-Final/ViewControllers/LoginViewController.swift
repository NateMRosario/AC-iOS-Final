//
//  ViewController.swift
//  AC-iOS-Final
//
//  Created by C4Q  on 2/22/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var authUserService = AuthUserService()
    var isNewUser = false
    
    private var tapGesture: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        authUserService.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    public static func storyboardInstance() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return loginController
    }
    

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard let emailText = emailTextField.text else {print("email is nil"); return}
        guard !emailText.isEmpty else {print("email is empty"); return}
        guard let passwordText = passwordTextField.text else {print("password is nil"); return}
        guard !passwordText.isEmpty else {print("password is empty"); return}
        if isNewUser {
            authUserService.createUser(email: emailText, password: passwordText)
        } else {
            authUserService.signIn(email: emailText, password: passwordText)
            isNewUser = true
        }
    }

    func errorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func loginAlert() {
        let alertController = UIAlertController(title: "Login Success", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            let tabController = TabBarController.storyboardInstance()
            self.present(tabController, animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
extension LoginViewController: AuthUserServiceDelegate {
    func didCreateUser(_ userService: AuthUserService, user: User) {
        print("didCreateUser: \(user)")
        loginAlert()
    }
    func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
        print("didFailCreatingUser: \(error)")
        errorAlert(title: "Error Creating User", message: error.localizedDescription)
    }
    
    func didSignIn(_ userService: AuthUserService, user: User) {
        loginAlert()
    }
    
    func didFailToSignIn(_ userService: AuthUserService, error: Error) {
        errorAlert(title: "Error Signing in User", message: error.localizedDescription)
    }
}



