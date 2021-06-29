//
//  IngredientListItem.swift
//  CookMe
//
//  Created by Hannes Koksch on 14.05.21.
//

import SwiftUI

// Helper view for creating interactable ingredients list in RecipeView
struct IngredientListItem : View {
    
    // context for database
    @Environment(\.managedObjectContext) var managedObjectContext
    var shoppingListItem: ShoppingListItem?
    var recipe: String?
    var item: String?
    @State var isOnShoppingList: Bool    
    
    init(shoppingListItem: ShoppingListItem?, recipe: String?, item: String?) {
        _isOnShoppingList = State(initialValue: shoppingListItem != nil)
        self.shoppingListItem = shoppingListItem
        self.recipe = recipe ?? shoppingListItem?.recipe
        self.item = item ?? shoppingListItem?.name
    }
    
    
    var body: some View {
        HStack {
            Text(item ?? "")
            Spacer()
            Button(action: {
                if isOnShoppingList{
                    guard let item = shoppingListItem else { return }
                    PersistenceController.shared.delete(item)
                } else {
                    let shoppingListItem = ShoppingListItem(context: managedObjectContext)
                    shoppingListItem.name = item
                    shoppingListItem.recipe = recipe
                    PersistenceController.shared.save()
                }
                isOnShoppingList.toggle()
            }){
                Image(systemName: isOnShoppingList ? "text.badge.plus" : "text.badge.checkmark")
                    .foregroundColor($isOnShoppingList.wrappedValue ? Color.red : Color.gray)
            }
        }
    }
}

struct IngredientListItem_Previews: PreviewProvider {
    static var previews: some View {
        IngredientListItem(shoppingListItem: ShoppingListItem(), recipe: "", item: "")
    }
}
