//
//  RecipeItemController.swift
//  Final_Project
//
//  Created by Hagai Kalinhoff on 06/07/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RecipeItemController: UIViewController {

    var email = ""
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var contentText: UITextView!
    
    @IBOutlet weak var recipeName: UILabel!
    
    
    
    @IBOutlet weak var autherEmail: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAuthorData()
    }
    
    func loadAuthorData(){
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(email)
        
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
                    self.authorImage.image = UIImage(data: imgData!)
                }
            }
        }
        
    }
    
}
