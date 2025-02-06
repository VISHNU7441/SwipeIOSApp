//
//  Untitled.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 02/02/25.
//
import SwiftUI

struct FavouriteProductCardView: View {
    @ObservedObject var viewModel:ListProductScreenViewModel
    let product:Product
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
                Text(String(format: "Rs %.2f", product.price ?? 0))
                    .font(.title2)
                    .bold()
                Text(String(format: "Tax: %.1f", product.tax ?? 0))
                    .font(.subheadline)
                    .padding(5)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.2))
                    }
            }
            .padding(.leading, 1)
        }
        .frame(width: 130, height: 200)
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 7)
        }
        .overlay(alignment:.topTrailing) {
            Image(systemName: "xmark")
                .padding()
                .background(.secondary.opacity(0.1))
                .clipShape(Circle())
                .onTapGesture {
                    viewModel.removeProductFromFavouriteList(product: product)
                }
        }
    }
}

#Preview {
    FavouriteProductCardView(viewModel: ListProductScreenViewModel(), product: .sampleData)
}
