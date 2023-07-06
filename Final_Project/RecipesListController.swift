//
//  RecipesListController.swift
//  Final_Project
//
//  Created by Hagai Kalinhoff on 06/07/2023.
//

import Foundation
import UIKit

class RecipesListController: UIViewController {

    let names = [
        "Jhones",
        "Dan bla",
        "Jason",
        "Keren",
        "Anat"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the data from the database
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
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
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        return cell
        
    }
    
}
