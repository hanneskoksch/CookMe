//
//  CategoryEditor.swift
//  CookMe
//
//  Created by Hannes Koksch on 18.06.21.
//

import SwiftUI

// Model for editing existing category
struct CategoryEditor: View {
    
    @Binding var categoryToEdit: Category?
    
    @State private var name: String = ""
    @State private var image: Image?
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    // Disables form if recipe title is not set. Prevents creation of null objects
    var disableForm: Bool {
        name.isEmpty
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
                        TextField("Neuer Name der Kategorie", text: $name)
                    }
                    
                    
                    Section {
                        HStack {
                            Spacer()
                            Button("Speichern") {
                                editRecipe()
                            }.disabled(disableForm)
                            Spacer()
                        }
                    }
                }
                
            }
            .onAppear(perform: {
                self.name = categoryToEdit!.name!
                self.image = categoryToEdit!.image?.getImage()
            })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .navigationTitle("Kategorie bearbeiten")
            .navigationBarItems(leading:
                                    Button("Abbrechen") {
                                        presentationMode.wrappedValue.dismiss()
                                    }, trailing:
                                        Button("Speichern") {
                                            editRecipe()
                                        }.disabled(disableForm))
        }
    }
    
    // Updates recipe object in database
    func editRecipe(){
        presentationMode.wrappedValue.dismiss()
        self.categoryToEdit!.name = self.name
        let imageData = inputImage?.jpegData(compressionQuality: 1.0)
        if (inputImage != nil) {
            // only overwrite image if a new one was selected
            categoryToEdit!.image = imageData
        }
        PersistenceController.shared.save()
    }
    
    // Loads selected image from image picker
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
}


struct CategoryEditor_Previews: PreviewProvider {
    @State static var categoryToEdit : Category?
    static var previews: some View {
        CategoryEditor(categoryToEdit: $categoryToEdit)
    }
}

