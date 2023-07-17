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
        
        recipeImage.layer.borderColor = UIColor.black.cgColor
        recipeImage.layer.borderWidth = 3
        
        editImageButon.layer.cornerRadius = editImageButon.bounds.height / 2
        editImageButon.clipsToBounds = true
        
        uploadButton.layer.cornerRadius =
            uploadButton.bounds.height / 2
        uploadButton.clipsToBounds = true

        // Make the text field start from the top-left
        recipeDescriptionInput.contentVerticalAlignment = .top
        
        
        
    }
    
    
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var prepTimeInput: UITextField!
    
    @IBOutlet weak var recipeNameInput: UITextField!
    
    @IBOutlet weak var recipeDescriptionInput: UITextField!
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var editImageButon: UIButton!
    
    @IBOutlet weak var uploadButton: UIButton!

    @IBAction func didTapUploadButton(_ sender: Any) {
        
        print("Button uplaod tapped")
        
        let vc  = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
        // Set the content mode to scaleAspectFit
        recipeImage.contentMode = .scaleAspectFit
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
    
    
   /* func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            recipeImage.image = image
        }
    
        picker.dismiss(animated: true, completion: nil)
    }*/
    
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
                recipeImage.image = image
            }
        
            picker.dismiss(animated: true, completion: nil)
        }*/
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
            if textField == recipeDescriptionInput {
                resizeFontToFitContent(textField)
            }
        }

        private func resizeFontToFitContent(_ textField: UITextField) {
            guard let text = textField.text else { return }
            
            let currentFontSize = textField.font?.pointSize ?? 20 // Set your initial font size here
            
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: currentFontSize)]
            let boundingRect = text.boundingRect(with: CGSize(width: textField.frame.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

            if boundingRect.height > textField.frame.height {
                let newFontSize = currentFontSize - 1
                if newFontSize >= 10 { // Set the minimum font size as needed
                    textField.font = UIFont.systemFont(ofSize: newFontSize)
                    resizeFontToFitContent(textField) // Recursively call to adjust the font size until it fits the content
                }
            }
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                recipeImage.image = editedImage
                adjustImageViewSize() // Resize the image view to fit the new image
            } else if let originalImage = info[.originalImage] as? UIImage {
                recipeImage.image = originalImage
                adjustImageViewSize() // Resize the image view to fit the new image
            }
        
            picker.dismiss(animated: true, completion: nil)
        }
    
    func adjustImageViewSize() {
        guard let image = recipeImage.image else { return }

        // Calculate the aspect ratio of the image
        let aspectRatio = image.size.width / image.size.height

        // Calculate the target width and height for the imageView
        let targetWidth = recipeImage.frame.width
        let targetHeight = targetWidth / aspectRatio

        // Create a new frame for the imageView with the calculated size
        let newFrame = CGRect(x: recipeImage.frame.origin.x, y: recipeImage.frame.origin.y, width: targetWidth, height: targetHeight)

        // Apply the new frame to the imageView
        recipeImage.frame = newFrame

        // Set the content mode to scaleAspectFit
        recipeImage.contentMode = .scaleAspectFit
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
