//
//  newRecipeController.swift
//  Final_Project
//
//  Created by Hagai Kalinhoff on 07/07/2023.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class NewRecipeController: UIViewController {

    override func viewDidLoad() {
        errorMsg.isHidden = true
        super.viewDidLoad()
    }
    
    
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var prepTimeInput: UITextField!
    
    @IBOutlet weak var recipeNameInput: UITextField!
    
    @IBOutlet weak var recipeDescriptionInput: UITextField!
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBAction func didTapUploadButton(_ sender: Any) {
        
        print("Button uplaod tapped")
        
        let vc  = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func didTapSubmitButton(_ sender: Any) {
        
        guard recipeImage.image != nil && prepTimeInput.text != nil && prepTimeInput.text != "" && recipeNameInput.text != nil && recipeNameInput.text != "" && recipeDescriptionInput.text != nil &&  recipeDescriptionInput.text != "" else{
            errorMsg.isHidden = false
            print("Something is nil")
            return
        }
        let storageRef = Storage.storage().reference()
        let imageData = recipeImage.image!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil  else {
            
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
                    let recipeObj = ["author": mail, "imageUrl": downloadURL.absoluteString, "recName": self.recipeNameInput.text!, "content": self.recipeDescriptionInput.text!, "prepTime": self.prepTimeInput.text!]
                 
                    db.collection("recipes/").document().setData(recipeObj)
                    
                    let alert = UIAlertController(title: "Recipe Uploaded", message: "Your recipe has uploaded successfully!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in}))
                    self.present(alert, animated: true)
                    self.errorMsg.isHidden = true
                    self.prepTimeInput.text = ""
                    self.recipeNameInput.text = ""
                    self.recipeImage.image = nil
                    self.recipeDescriptionInput.text = ""
                }

                
                
            }
            
        }
        
        
        
    }
}

extension NewRecipeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            recipeImage.image = image
        }
    
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
