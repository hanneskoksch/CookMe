//
//  IngredientCreation.swift
//  CookMe
//
//  Created by Liliya Ivanova on 07.06.2021.
//

import SwiftUI

// Sheet dialog for adding ingredients to shopping list
struct IngredientCreation: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var ingredientName = ""
    
    var disableForm: Bool {
        ingredientName.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                Form {
                    Section(header: Text("Informationen")) {
                        TextField("Name der Zutat", text: $ingredientName)
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            Button("Zutat hinzufügen") {
                                addIngredient()
                            }
                            Spacer()
                        }
                    }.disabled(disableForm)
                }
                
            }
            .navigationTitle("Zur Liste hinzufügen")
            .navigationBarItems(leading: Button("Abbrechen") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Hinzufügen") {
                addIngredient()
            }.disabled(disableForm))
        }
    }
    
    // Saves added ingredient to database
    func addIngredient() {
        presentationMode.wrappedValue.dismiss()
        
        let shoppingListItem = ShoppingListItem(context: managedObjectContext)
        shoppingListItem.name = ingredientName
        PersistenceController.shared.save()
    }
}

struct IngredientCreation_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCreation()
    }
}

