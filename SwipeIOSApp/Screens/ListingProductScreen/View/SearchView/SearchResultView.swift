//
//  SearchResultView.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 06/02/25.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var viewModel:ListProductScreenViewModel
    var body: some View {
        VStack(alignment:.center){
          if !viewModel.listOfSearchResults.isEmpty {
                ScrollView{
                    VStack{
                        ForEach(viewModel.listOfSearchResults){ product in
                            SearchProductView(product: product)
                                .padding()
                        }
                    }
                }
          }else{
              Text("Not found")
          }
            
        }
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    SearchResultView()
        .environmentObject(ListProductScreenViewModel())
}
