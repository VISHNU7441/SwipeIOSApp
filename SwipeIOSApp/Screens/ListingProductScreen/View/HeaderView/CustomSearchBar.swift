//
//  CustomSearchBar.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import SwiftUI

struct CustomSearchBar: View {
    @EnvironmentObject var viewModel:ListProductScreenViewModel
    @State private var searchedTerm:String = ""
    @FocusState private var isTextFieldFocused
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .imageScale(.medium)
                .foregroundStyle(.gray)
            TextField(text: $searchedTerm) {
                Text("Search for what you are looking..")
                    .bold()
            }
            .focused($isTextFieldFocused)
            Image(systemName: "chevron.forward")
                .imageScale(.small)
                .onTapGesture {
                    viewModel.isSearching = false
                    searchedTerm = ""
                    isTextFieldFocused = false
                }
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 17)
                .strokeBorder()
                .foregroundStyle(.gray)
        }
        .onTapGesture {
            isTextFieldFocused.toggle()
        }
        .onChange(of: searchedTerm) { _ , newValue in
            viewModel.callTheSearchFunctionWithDebounce(searchTerm: newValue)
        }
    }
    
}

#Preview {
    NavigationView{
        CustomSearchBar()
    }
}
