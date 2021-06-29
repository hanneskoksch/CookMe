//
//  ShoppingListModel.swift
//  CookMe
//
//  Created by Liliya Ivanova on 10.06.2021.
//

import Foundation

// Model for shopping list item
class ShoppingListModel: Identifiable {
    
    var recipe: String?
    var ingredients: [String]
    
    init(recipe: String?, ingredients: [String]) {
        self.recipe = recipe
        self.ingredients = ingredients
    }
}
