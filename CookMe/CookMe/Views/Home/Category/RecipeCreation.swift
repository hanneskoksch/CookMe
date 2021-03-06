//
//  RecipeCreation.swift
//  CookMe
//
//  Created by Torben Ziegler on 25.05.21.
//

import SwiftUI
import Combine

// Sheet dialog for creating a recipe
struct RecipeCreation: View {
    
    // Context for database
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var recipeTitle = ""
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var numOfPeople: String = ""
    @State private var prepTime: String = ""
    @State private var description: String = ""
    @State private var instructions: [String] = []
    @State private var currentStep: String = ""
    @State private var ingredients: [String] = []
    @State private var currentIngredient: String = ""
    var category: Category
    
    // Disables form if recipe title is not set. Prevents creation of null objects
    var disableForm: Bool {
        recipeTitle.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                Form {
                    Section {
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 200)
                            
                            if image != nil {
                                image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200, alignment: .center)
                            } else {
                                Text("Tippen um Bild auszuwählen")
                                    .foregroundColor(.secondary)
                                    .font(.headline)
                            }
                        }
                        .ignoresSafeArea()
                        .onTapGesture {
                            self.showingImagePicker = true
                        }
                    }
                    Section(header: Text("Informationen")) {
                        TextField("Name des Rezeptes", text: $recipeTitle)
                        TextField("Beschreibung", text: $description)
                        TextField("Anzahl Personen", text: $numOfPeople)
                            .keyboardType(.numberPad)
                        TextField("Zeitaufwand in Minuten", text: $prepTime)
                            .keyboardType(.numberPad)
                    }
                    
                    Section(header: Text("Zutaten")) {
                        List {
                            ForEach(Array(ingredients.enumerated()), id: \.offset) { index, ingredient in
                            Text("\(index + 1). \(ingredient)")
                        }.onDelete(perform: deleteIngredient)
                            HStack {
                                TextField("Neue Zutat", text: $currentIngredient)
                                Spacer()
                                Button("Hinzufügen") {
                                    ingredients.append(currentIngredient)
                                    currentIngredient = ""
                                }
                            }
                        }
                    }
                    
                    Section (header: Text("Anleitung")){
                        List {ForEach(Array(instructions.enumerated()), id: \.offset) { index, step in
                            Text("\(index + 1). \(step)")
                        }
                        .onDelete(perform: deleteInstruction)
                        }
                        HStack {
                            TextField("Neuer Schritt", text: $currentStep)
                            Spacer()
                            Button("Hinzufügen") {
                                instructions.append(currentStep)
                                currentStep = ""
                            }
                        }
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            Button("Rezept erstellen") {
                                createRecipe()
                            }
                            Spacer()
                        }
                    }.disabled(disableForm)
                }
                
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .navigationTitle("Neues Rezept")
            .navigationBarItems(leading:
                                    Button("Abbrechen") {
                                        presentationMode.wrappedValue.dismiss()
                                    }, trailing:
                                        Button("Erstellen") {
                                            createRecipe()
                                        }
                                        .disabled(disableForm))
        }
    }
    
    // Saves created recipe in database
    func createRecipe(){
        presentationMode.wrappedValue.dismiss()
        let recipe = Recipe(context: managedObjectContext)
        recipe.category = self.category
        recipe.isFavorite = false
        recipe.name = self.recipeTitle
        recipe.recipeDescription = self.description
        recipe.instructionTime = Int16(prepTime) ?? 0
        recipe.persons = Int16(numOfPeople) ?? 0
        let imageData = inputImage?.jpegData(compressionQuality: 1.0)
        recipe.image = imageData
        recipe.ingredients = self.ingredients.joined(separator: ">>")
        recipe.instructions = self.instructions.joined(separator: ">>")
        print(recipe)
        PersistenceController.shared.save()
    }
    
    // Deletes added ingredient in form
    func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    // Deletes added instruction step in form
    func deleteInstruction(at offsets: IndexSet) {
        instructions.remove(atOffsets: offsets)
    }
    
    // Loads selected image from image picker 
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct RecipeCreation_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCreation( category: Category())
    }
}

