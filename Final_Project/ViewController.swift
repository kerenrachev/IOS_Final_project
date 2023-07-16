//
//  ViewController.swift
//  Final_Project
//
//  Created by Hagai Kalinhoff on 06/07/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = submitButton.bounds.height / 2
        submitButton.clipsToBounds = true
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            //loginLabel.isHidden = true
            //emailAddress.isHidden = true
            //password.isHidden = true
            //submitButton.isHidden = true
        }
        initClickListeners()
        // Do any additional setup after loading the view.
    }
    
    var defUserPic = "https://cdn.vectorstock.com/i/1000x1000/30/97/flat-business-man-user-profile-avatar-icon-vector-4333097.webp"
    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    private func initClickListeners(){
    
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    
//    @objc private func submitButtonTapped(){
//        guard let email = emailAddress.text, !email.isEmpty,
//              let passwordVal = password.text, !passwordVal.isEmpty else{
//                  print("Missing email or password")
//                  return
//              }
//
//        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: passwordVal, completion: { [weak self] result, error in
//
//            guard let strongSelf = self else{
//                return
//            }
//
//            guard error == nil else{
//                // Show account creation
//                strongSelf.showCreateAccount(email: email, password: passwordVal)
//                return
//            }
//
//            strongSelf.emailAddress.resignFirstResponder()
//            strongSelf.password.resignFirstResponder()
//
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
//
//            tabBarController.modalPresentationStyle = .fullScreen
//            strongSelf.show(tabBarController, sender: self)
//
//        })
//    }
    @objc private func submitButtonTapped() {
        guard let email = emailAddress.text, !email.isEmpty,
              let passwordVal = password.text, !passwordVal.isEmpty else {
                  print("Missing email or password")
                  return
              }

        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: passwordVal) { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                if let errorCode = AuthErrorCode.Code(rawValue: error?._code ?? 0) {
                    switch errorCode {
                    case .wrongPassword:
                        // Show message for wrong password
                        strongSelf.showAlert(title: "Error", message: "Incorrect password")
                    case .userNotFound:
                        // Show account creation
                        strongSelf.showCreateAccount(email: email, password: passwordVal)
                    default:
                        // Show generic error message
                        print("Sign-in error: \(error!.localizedDescription)")
                    }
                }
                return
            }

            strongSelf.emailAddress.resignFirstResponder()
            strongSelf.password.resignFirstResponder()

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController

            tabBarController.modalPresentationStyle = .fullScreen
            strongSelf.show(tabBarController, sender: self)
        }
    }
    
    private func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }



    
    func showCreateAccount (email: String, password: String){
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, error in
                guard let strongSelf = self else{
                    return
                }
                
                guard error == nil else{
                    // Show account creation
                    print("Account creation failed")
                    return
                }
                
                // Create the user in the database with default picture, and empty array of favorite recipes
                let db = Firestore.firestore()
                db.collection("users").document(FirebaseAuth.Auth.auth().currentUser!.email!).setData(["picUrl": strongSelf.defUserPic, "favorites": [] ])
                
                // Close keyboard
                strongSelf.emailAddress.resignFirstResponder()
                strongSelf.password.resignFirstResponder()
                
                
                // Open the application
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                tabBarController.modalPresentationStyle = .fullScreen
                strongSelf.show(tabBarController, sender: self)
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))
        
        present(alert, animated: true)
        
    }
    
    
}

