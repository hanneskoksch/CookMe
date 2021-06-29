//
//  ImagePicker.swift
//  CookMe
//
//  Created by Torben Ziegler on 12.05.21.
//

import SwiftUI

// Helper for picking image from the local gallery
struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // Called when user has selected an image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as?
            UIImage {
                parent.image = uiImage
            }
            // Closes ImagePicker sheet
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    // Creates view to pick image from gallery
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>)
    -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}

// Extension for loading images from data in views. Converts data to UIImage
extension Data {
    func getImage() -> Image {
        return Image(uiImage: UIImage(data: self) ?? UIImage())
    }
}
