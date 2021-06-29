//
//  CookMeTests.swift
//  CookMeTests
//
//  Created by Torben Ziegler on 11.05.21.
//

import XCTest
import CoreData
import SwiftUI
@testable import CookMe

class CookMeTests: XCTestCase {
    
    // Tests creation of Recipe object
    func testRecipeCreation() throws {
        let recipe = Recipe(context: PersistenceController.shared.container.viewContext)
        
        recipe.name = "Unit Test Recipe"
        print(recipe.name ?? "Error")
        XCTAssertEqual(recipe.name, "Unit Test Recipe")
        XCTAssertNotEqual(recipe.name, "UI Test")
        
        recipe.isFavorite = true
        XCTAssertTrue(recipe.isFavorite)
    }
    
    // Tests creation of Category object
    func testCategoryCreation() throws {
        let category = Category(context: PersistenceController.shared.container.viewContext)
        
        category.name = "Test Category"
        category.isFavorite = true
        
        XCTAssertEqual(category.name, "Test Category")
        XCTAssertNotEqual(category.name, "Actual Category")
        XCTAssertTrue(category.isFavorite)
        XCTAssertNil(category.image)
    }
    
    // Tests fetching created recipe from database
    func testRecipeFetch() {
        var fetchRequest: FetchRequest<Recipe>
        var items: FetchedResults<Recipe>{fetchRequest.wrappedValue}
        
        let recipe = Recipe(context: PersistenceController.shared.container.viewContext)
        recipe.name = "Unit Test Recipe"
        
        PersistenceController.shared.save()
        
        // Fetching created object
        fetchRequest = FetchRequest(entity: Recipe.entity(),
                                         sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)], predicate: NSPredicate(format: "name == %@", recipe))
        
        // Checking retrieved object for existence
        for item in items {
            if item.name == "Unit Test Recipe" {
                XCTAssertTrue(item.name == "Unit Test Recipe")
            }
            print(item.name ?? "No name")
        }
    }

}
