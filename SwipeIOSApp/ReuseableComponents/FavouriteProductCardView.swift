//
//  Untitled.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 02/02/25.
//
import SwiftUI

struct ProductCardView: View {
    @ObservedObject var viewModel:ListProductScreenViewModel
    let product:Product
    @State private var isFavourite = false
    var body: some View {
        VStack(alignment:.leading){
            ZStack{
                AsyncImage(url: URL(string: product.image ?? "")){ value in
                    switch value {
                    case .empty:
                        Image("default")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure:
                        ProgressView()
                    @unknown default:
                        fatalError()
                    }
                }
            }
            .frame(width: 100, height: 100)
            
            Group{
                Text(product.productName.capitalized)
                    .font(.title3)
                    .lineLimit(1, reservesSpace: false)
                    .multilineTextAlignment(.leading)
                Text(String(format: "Rs %.2f", product.price))
                    .font(.title2)
                    .bold()
                Text(String(format: "Tax: %.1f", product.tax))
                    .font(.subheadline)
                    .padding(5)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.2))
                    }
            }
            .padding(.leading, 1)
        }
        .frame(maxWidth: 130)
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 7)
        }
        .overlay(alignment:.topTrailing) {
            Image(systemName: "heart.fill")
                .foregroundStyle(isFavourite ? Color.red.opacity(0.6) : Color.white )
                .padding()
                .background(.secondary.opacity(0.4))
                .clipShape(Circle())
                .onTapGesture {
                    isFavourite.toggle()
                }
        }
        .onChange(of: isFavourite){
            if isFavourite{
                viewModel.updateListOfFavouriteProducts(product: product)
            }else{
                viewModel.removeProductFromFavouriteList(product: product)
            }
            
        }
       
    }
}
