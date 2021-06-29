//
//  CategoryCreation.swift
//  CookMe
//
//  Created by Hannes Koksch on 29.05.21.
//

import SwiftUI

// Sheet dialog for creating a category
struct CategoryCreation: View {
    
    // Context for database
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @State var categoryName = ""
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @StateObject var viewModel = Category()
    @State private var showingAlert = false
    
    // Disables form if category name is not set. Prevents creation of null objects
    var disableForm: Bool {
        categoryName.isEmpty
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
                        TextField("Name der Kategorie", text: $categoryName)
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            Button("Kategorie erstellen") {
                                if categories.contains(where: {$0.name == categoryName}){
                                    showingAlert.toggle()
                                } else {
                                   createCategory()
                                }
                            }.disabled(disableForm)
                            Spacer()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .alert(isPresented: $showingAlert) { // Prevents creation of duplicated category names
                Alert(title: Text(""), message: Text("Diese Kategorie ist schon vorhanden. Wählen Sie bitte eine andere Kategorie aus"), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Neue Kategorie")
            .navigationBarItems(leading:
                                    Button("Abbrechen") {
                                        presentationMode.wrappedValue.dismiss()
                                    }, trailing:
                                        Button("Erstellen") {
                                            createCategory()
                                        }.disabled(disableForm)
                                
            )
        }
    }
    
    // Saves created category to database
    func createCategory() {
        presentationMode.wrappedValue.dismiss()
        let category = Category(context: managedObjectContext)
        category.name = self.categoryName
        category.isFavorite = false
        let imageData = inputImage?.jpegData(compressionQuality: 1.0)
        category.image = imageData
        print(category)
        PersistenceController.shared.save()
    }
    
    // Loads selected image from image picker 
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct CategoryCreation_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCreation()
    }
}

