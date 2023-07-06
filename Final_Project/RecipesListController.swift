//
//  RecipesListController.swift
//  Final_Project
//
//  Created by Hagai Kalinhoff on 06/07/2023.
//

import Foundation
import UIKit

class RecipesListController: UIViewController {

    var recipes: [Recipe] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initObject()
        
        // Get the data from the database
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func initObject(){
        let rec1 = Recipe(author: "test1", imageUrl: "https://hips.hearstapps.com/hmg-prod/images/classic-cheese-pizza-recipe-2-64429a0cb408b.jpg?crop=0.6666666666666667xw:1xh;center,top&resize=1200:*", recName: "test1", content: "dfbfldfbdfbdfbbf", prepTime: "1 hour")
        let rec2 = Recipe(author: "test2", imageUrl: "https://hips.hearstapps.com/hmg-prod/images/classic-cheese-pizza-recipe-2-64429a0cb408b.jpg?crop=0.6666666666666667xw:1xh;center,top&resize=1200:*", recName: "test1", content: "dfbfldfbdfbdfbbf", prepTime: "1 hour")
        let rec3 = Recipe(author: "test3", imageUrl: "https://hips.hearstapps.com/hmg-prod/images/classic-cheese-pizza-recipe-2-64429a0cb408b.jpg?crop=0.6666666666666667xw:1xh;center,top&resize=1200:*", recName: "test1", content: "dfbfldfbdfbdfbbf", prepTime: "1 hour")
        let rec4 = Recipe(author: "test4", imageUrl: "https://hips.hearstapps.com/hmg-prod/images/classic-cheese-pizza-recipe-2-64429a0cb408b.jpg?crop=0.6666666666666667xw:1xh;center,top&resize=1200:*", recName: "test1", content: "dfbfldfbdfbdfbbf", prepTime: "1 hour")
        let rec5 = Recipe(author: "test5", imageUrl: "https://hips.hearstapps.com/hmg-prod/images/classic-cheese-pizza-recipe-2-64429a0cb408b.jpg?crop=0.6666666666666667xw:1xh;center,top&resize=1200:*", recName: "test1", content: "dfbfldfbdfbdfbbf", prepTime: "1 hour")
        let rec6 = Recipe(author: "test6", imageUrl: "https://hips.hearstapps.com/hmg-prod/images/classic-cheese-pizza-recipe-2-64429a0cb408b.jpg?crop=0.6666666666666667xw:1xh;center,top&resize=1200:*", recName: "test1", content: "dfbfldfbdfbdfbbf", prepTime: "1 hour")
        
        recipes.append(rec1)
        recipes.append(rec2)
        recipes.append(rec3)
        recipes.append(rec4)
        recipes.append(rec5)
        recipes.append(rec6)
    }
}




extension RecipesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
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
