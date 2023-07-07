//
//  ProfileController.swift
//  Final_Project
//
//  Created by Hagai Kalinhoff on 07/07/2023.
//
import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class ProfileController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromDB()
    }
    
    
    @IBAction func logoutDidTapped(_ sender: Any) {
        
        do {
          try FirebaseAuth.Auth.auth().signOut()
            dismiss(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
        
    }
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func uploadImageButton(_ sender: Any) {
        
        print("Change picture button tapped")
    }
    
    @IBOutlet weak var userEmail: UILabel!
    
    func loadDataFromDB(){
        
        let currUserEmail = FirebaseAuth.Auth.auth().currentUser!.email!
        userEmail.text = currUserEmail
        
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(currUserEmail)
        
        docRef.getDocument{ (document, error) in
            guard error == nil else {
                print("Error retrieving user's document")
                return
                
            }
            
            if let document = document, document.exists{
                let data = document.data()
                if let data = data {
                    
                    let profilePic = data["picUrl"]
                    let url = URL(string: profilePic as! String)
                    let imgData = try? Data(contentsOf: url!)
                    self.profileImage.image = UIImage(data: imgData!)
                }
            }
        }
        
            
    }
}
