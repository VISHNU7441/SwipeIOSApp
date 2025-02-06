//
//  CategoryView.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import SwiftUI

struct CategoryView: View {
    var body: some View {
        ScrollView(.horizontal){
            HStack(spacing: 20){
                ForEach(ProductType.allCases, id:\.rawValue){ product in
                    VStack{
                        Image(product.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipped()
                            .clipShape(.circle)
                            .shadow(radius: 2)
                        
                        Text(product.rawValue.capitalized)
                            .font(.footnote)
                            .bold()
                            .lineLimit(2, reservesSpace: true)
                    }
                        
                }
            }
            .onTapGesture {
                // call the products
            }
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    CategoryView()
}
