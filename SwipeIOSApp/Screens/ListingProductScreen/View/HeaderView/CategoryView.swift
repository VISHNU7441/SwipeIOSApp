//
//  CategoryView.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject private var viewModel:ListProductScreenViewModel
    var body: some View {
        ScrollView(.horizontal){
            HStack(spacing: 20){
                ForEach(viewModel.listOfProductType, id: \.self){ product in
                        Text(product)
                            .font(.footnote)
                            .bold()
                            .lineLimit(2, reservesSpace: true)
                            .onTapGesture {
                                // call the products
                               // viewModel.selectedProductType = product
                                viewModel.updateListView(selectedType: product)
                            }
  
                }
            }
          
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .scrollBounceBehavior(.basedOnSize)
    }
}

//#Preview {
//    CategoryView()
//}
