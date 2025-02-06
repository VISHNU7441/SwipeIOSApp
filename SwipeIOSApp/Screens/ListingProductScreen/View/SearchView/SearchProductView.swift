//
//  SearchProductView.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 06/02/25.
//

import SwiftUI

struct SearchProductView: View {
    @EnvironmentObject var viewModel:ListProductScreenViewModel
    let product:Product
    private var isAvailableInFavouriteList:Bool{
        viewModel.isThisProductPresentInFavouriteList(product: product)
    }
    var body: some View {
        HStack{
            ZStack{
                AsyncImage(url: URL(string: product.image ?? "")){ result in
                    switch result {
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
                        fatalError("Unable to process the image")
                    }
                    
                }
            }
            .frame(width: 100, height: 100)
            .padding(.horizontal)
            
            VStack(alignment:.leading, spacing: 7){
                Text(product.productName.capitalized)
                    .foregroundStyle(.primary)
                    .bold()
                    .lineLimit(1, reservesSpace: true)

                Text(product.productType)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)

                HStack(spacing: 10){
                    Text(String(format: "$%0.2f", product.price ?? 0))
                        .bold()
                        .font(.subheadline)
                }
            }
            Spacer()
            Image(systemName: "heart.fill")
                .foregroundStyle(isAvailableInFavouriteList ? .swipeButtonColour : Color.white)
                .imageScale(.large)
                .padding(12)
                .background{
                    Circle()
                        .fill(.gray.opacity(0.2))
                }
                .padding(.horizontal)
        
      }
        .frame(height: 110)
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(radius: 4)
        }
        
    }
}

#Preview {
    SearchProductView(product: .sampleData)
        .environmentObject(ListProductScreenViewModel())
}
