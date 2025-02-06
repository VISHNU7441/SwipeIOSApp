//
//  ListingProductsScreen.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import SwiftUI

struct ListingProductsScreen: View {
    @StateObject var viewModel = ListProductScreenViewModel()
   // @State private var selectedProductType:ProductType = .all
    private let columns:[GridItem] = [GridItem(spacing: 4), GridItem(spacing: 4)]
    var body: some View {
        VStack{
            HeaderView()
            ScrollView{
                VStack{
                    ZStack{
                        if !viewModel.listOfFavouriteProducts.isEmpty {
                            FavouriteView(viewModel: viewModel)
                        }
                    }
                    VStack(alignment:.leading){
                        Text(viewModel.currentProductType)
                            .font(.title3)
                            .bold()
                        
                        LazyVGrid(columns: columns){
                            ForEach(viewModel.listOfProducts){ product in
                                ProductCardView(viewModel: viewModel, product: product)
                            }
                        }
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                
            }
            .scrollIndicators(.hidden)
        
            
        }
        .padding()
        .onAppear{
            viewModel.updateListOfProducts()
        }
        .navigationBarBackButtonHidden()
        .environmentObject(viewModel)
    }
}

#Preview {
    NavigationStack{
        ListingProductsScreen()
    }
}
