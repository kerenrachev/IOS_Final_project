//
//  Recipe.swift
//  Final_Project
//
//  Created by Hagai Kalinhoff on 06/07/2023.
//

import Foundation


class Recipe {
    
    var author: String
    var imageUrl: String
    var recName: String
    var content: String
    var prepTime: String
    
    init(author: String, imageUrl: String, recName: String, content: String, prepTime: String){
        
        self.author = author
        self.imageUrl = imageUrl
        self.recName = recName
        self.content = content
        self.prepTime = prepTime
    }
    
    
    
}
