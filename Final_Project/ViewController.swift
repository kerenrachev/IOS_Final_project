//
//  ViewController.swift
//  Final_Project
//
//  Created by Hagai Kalinhoff on 06/07/2023.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            //loginLabel.isHidden = true
            //emailAddress.isHidden = true
            //password.isHidden = true
            //submitButton.isHidden = true
        }
        initClickListeners()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    private func initClickListeners(){
    
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func submitButtonTapped(){
        print("Button clcicked!!!")
        guard let email = emailAddress.text, !email.isEmpty,
              let passwordVal = password.text, !passwordVal.isEmpty else{
                  print("Missing email or password")
                  return
              }
        
        // GEt Auth instance
        
        //Atempt sign-in
        
        // If failure, present alert to create accounr
        
        // If user continues, create account
        
        // Check sign in on app launch
        
        // Allow user to sign out with button
        
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: passwordVal, completion: { [weak self] result, error in
            
            guard let strongSelf = self else{
                return
            }
            
            guard error == nil else{
                // Show account creation
                strongSelf.showCreateAccount(email: email, password: passwordVal)
                return
            }
            
            
            print ("You have signed in")
            strongSelf.emailAddress.resignFirstResponder()
            strongSelf.password.resignFirstResponder()
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! TabBarController
            
            
            //strongSelf.present(gameController, animated: true, completion: nil)
            strongSelf.show(tabBarController, sender: self)
            
        })
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
                
                
                print ("You have signed in")
                
                strongSelf.emailAddress.resignFirstResponder()
                strongSelf.password.resignFirstResponder()
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! TabBarController
                
                strongSelf.show(tabBarController, sender: self)
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))
        
        present(alert, animated: true)
        
    }
    
    
}

