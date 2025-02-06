//
//  ListingProductsScreen.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import SwiftUI

struct ListingProductsScreen: View {
    @StateObject var viewModel = ListProductScreenViewModel()
    private let columns:[GridItem] = [GridItem(spacing: 4), GridItem(spacing: 4)]
    @State private var isSearching:Bool = true
    var body: some View {
            VStack{
                HeaderView()
                ZStack(alignment:.topLeading){
                    ScrollView{
                        VStack{
                            ZStack{
                                if !viewModel.listOfFavouriteProducts.isEmpty {
                                    FavouriteView(viewModel: viewModel)
                                }
                            }
                            VStack(alignment:.leading){
                                Text(viewModel.currentProductType.capitalized)
                                    .font(.title3)
                                    .bold()

                                
                                LazyVGrid(columns: columns){
                                    ForEach(viewModel.listOfProducts){ product in
                                        ProductCardView(product: product)
                                    }
                                }
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .scrollIndicators(.hidden)
                // SearchResultScreen()
                    if viewModel.isSearching{
                        SearchResultView()
                    }
                }
            }
            .padding()
            .ignoresSafeArea(edges: .bottom)
            .overlay(alignment: .bottomTrailing, content: {
                NavigationLink {
                    AddProductScreen()
                } label: {
                    AddProductButton()
                        .padding(.horizontal)
                }

            })
            .onAppear{
                viewModel.updateListOfProducts()
                viewModel.fetchFavouriteProductList()
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
