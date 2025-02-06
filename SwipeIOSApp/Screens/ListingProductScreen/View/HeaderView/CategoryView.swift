//
//  CategoryView.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject private var viewModel:ListProductScreenViewModel
    @State var selectedProduct = ""
    var body: some View {
        ScrollView(.horizontal){
            HStack(spacing: 20){
                ForEach(viewModel.listOfProductType, id: \.self){ product in
                    Text(product.description.capitalized)
                            .font(.footnote)
                            .bold()
                            .foregroundStyle(selectedProduct == product ? Color.white : Color.black)
                            .padding(.horizontal, 3)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedProduct == product ? Color.swipeButtonColour : Color.clear)
                                    .frame(minWidth: 20, minHeight: 30)
                                
                            })
                            .onTapGesture {
                                viewModel.updateListView(selectedType: product)
                                withAnimation(.easeInOut){
                                    selectedProduct = product
                                }
                            }
                }
            }
          
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .scrollBounceBehavior(.basedOnSize)
    }
}
#Preview {
    NavigationStack{
        ListingProductsScreen()
    }
}
