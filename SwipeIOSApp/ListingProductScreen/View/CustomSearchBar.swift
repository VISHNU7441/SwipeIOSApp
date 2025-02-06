//
//  CustomSearchBar.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import SwiftUI

struct CustomSearchBar: View {
    @State private var searchedTerm:String = ""
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .imageScale(.medium)
                .foregroundStyle(.gray)
            TextField(text: $searchedTerm) {
                Text("Search for what you are looking..")
                    .bold()
            }
            Image(systemName: "chevron.forward")
                .imageScale(.small)
           
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 17)
                .strokeBorder()
                .foregroundStyle(.gray)
        }
        .padding(10)
    }
}

#Preview {
    CustomSearchBar()
}
