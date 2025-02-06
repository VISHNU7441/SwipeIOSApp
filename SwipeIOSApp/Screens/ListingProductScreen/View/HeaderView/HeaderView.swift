//
//  HeaderView.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//
import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack{
            CustomSearchBar()
            VStack(alignment:.leading){
                Text("Browse Categories")
                    .font(.title3)
                    .bold()
            CategoryView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Image("swipeLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 50)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // for any notifications (Future addition)
                } label: {
                    Image(systemName: "bell")
                        .foregroundStyle(.black)
                        .padding(5)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder()
                        }
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        ListingProductsScreen()
    }
}
