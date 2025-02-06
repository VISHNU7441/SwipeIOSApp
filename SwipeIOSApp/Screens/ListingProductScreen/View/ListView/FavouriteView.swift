//
//  FavouriteView.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import SwiftUI

struct FavouriteView: View {
    @ObservedObject var viewModel:ListProductScreenViewModel
    var body: some View {
        VStack(alignment:.leading){
            Text("Favourite")
                .font(.title3)
                .bold()
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(viewModel.listOfFavouriteProducts){ product in
                        FavouriteProductCardView(viewModel: viewModel, product: product)
                    }
                }
                .padding()
            }
            .scrollClipDisabled()
        }
    }
}


