//
//  CategoryCard.swift
//  CookMe
//
//  Created by Torben Ziegler on 11.05.21.
//

import SwiftUI

// Model for category card view
struct CategoryCard: View {
    
    @ObservedObject var category: Category
    
    var body: some View {
        VStack {
            if category.image != nil {
                category.image?.getImage() // Using extension for converting data to UIImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(20)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.pink)
                        .frame(height: 200)
                        .cornerRadius(20)
                    
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                   
                }
               
            }
            
            Text(category.name ?? "Kein Name")
                .foregroundColor(.white)
                .padding(.all, 10)
                .padding([.leading, .trailing], 30)
                .background(Color.pink)
                .cornerRadius(20)
        }
    }
}
 
struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCard(category: Category())
    }
}

