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
        
        profileImage.layer.cornerRadius = 20
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 3
        
        uploadImage.layer.cornerRadius = uploadImage.bounds.height / 2
        uploadImage.clipsToBounds = true
        
        logoutButton.layer.cornerRadius = logoutButton.bounds.height / 2
        logoutButton.clipsToBounds = true
        
        logoutButton.layer.borderWidth = 3
        logoutButton.layer.borderColor = UIColor.red.cgColor
        
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
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func uploadImageButton(_ sender: Any) {
        
        print("Change picture button tapped")
        let vc  = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
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


extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profileImage.image = image
            
            
            guard profileImage.image != nil else{
                return
            }
            let storageRef = Storage.storage().reference()
            let imageData = profileImage.image!.jpegData(compressionQuality: 0.8)
            
            guard imageData != nil else {
                return
            }
            
            let fileRef = storageRef.child("images/" + UUID().uuidString + ".jpeg")
            
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                
                if error == nil && metadata != nil {
                    // Save a reference intht database
                    print("Uploaded pictre")
                    
                    let db = Firestore.firestore()
                    // You can also access to download URL after upload.
                    fileRef.downloadURL { (url, error) in
                      guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                      }
                    let mail = FirebaseAuth.Auth.auth().currentUser!.email!
                        db.collection("users/").document(mail).updateData(["picUrl":downloadURL.absoluteString])
                        
                    let alert = UIAlertController(title: "Image Uploaded", message: "Your new profile image has uploaded successfully!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in}))
                        self.present(alert,animated: true)
                    }

                    
                    
                }
                
            }
            // Replace user's image in the database and display alert
        }
    
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
