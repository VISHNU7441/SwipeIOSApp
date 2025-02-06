//
//  ContentView.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack {
                Image("swipeLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200, maxHeight: 100)
               
            }
            .frame(minHeight: 300, alignment: .center)
            .overlay(alignment:.bottomTrailing){
                NavigationLink {
                    ListingProductsScreen()
                } label: {
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(.white)
                        .padding()
                        .padding(.horizontal,2)
                        .background{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.swipeButtonColour)
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
