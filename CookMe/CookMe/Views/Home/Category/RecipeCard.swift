//
//  RecipeCard.swift
//  CookMe
//
//  Created by Hannes Koksch on 18.06.21.
//

import SwiftUI

struct RecipeCard: View {
    
    var item: Recipe
    
    var body: some View {
        VStack (alignment: .center){
            if item.image != nil {
                item.image?.getImage() // Using extension for converting data to UIImage
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
            
            Text(item.name ?? "Kein Titel")
                .foregroundColor(.white)
                .padding(.all, 10)
                .padding([.leading, .trailing], 30)
                .background(Color.pink)
                .cornerRadius(20)
        }
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(item: Recipe())
    }
}
