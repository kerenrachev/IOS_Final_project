//
//  RecipesListController.swift
//  Final_Project
//
//  Created by Hagai Kalinhoff on 06/07/2023.
//

import Foundation
import UIKit
import FirebaseFirestore
class RecipesListController: UIViewController {

    var recipes: [Recipe] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        retrieveRecipes()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveRecipes()
    }
    
    func retrieveRecipes(){
        
        recipes = []
        tableView.reloadData()
        
        let db = Firestore.firestore()
        
        db.collection("recipes").getDocuments{snapshot, error in
            if error == nil && snapshot != nil{
                for doc in snapshot!.documents {
                    let recipe = Recipe(author: doc["author"] as! String, imageUrl: doc["imageUrl"] as! String, recName: doc["recName"] as! String, content: doc["content"] as! String, prepTime: doc["prepTime"] as! String)
                    self.recipes.append(recipe)
                }
                
                self.tableView.reloadData()
                
            }
            
        }
        
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
}

extension RecipesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let recipeItemController = storyBoard.instantiateViewController(withIdentifier: "recipeItemController") as! RecipeItemController
        
        
        let url = URL(string: recipes[indexPath.row].imageUrl )
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        self.show(recipeItemController, sender: self)
        recipeItemController.imageView.image = UIImage(data: data!)
        recipeItemController.nameLabel.text = recipes[indexPath.row].recName
        recipeItemController.timeLabel.text = recipes[indexPath.row].prepTime
        recipeItemController.contentText.text = recipes[indexPath.row].content
    }
}

extension RecipesListController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellRec
        
        
        let url = URL(string: recipes[indexPath.row].imageUrl )
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.recImage.image = UIImage(data: data!)
        cell.recName.text = recipes[indexPath.row].recName
        cell.prepTime.text = recipes[indexPath.row].prepTime
        
        //cell.recImage.image
        //cell.textLabel?.text = recipes[indexPath.row].author
        return cell
        
    }
    
}
