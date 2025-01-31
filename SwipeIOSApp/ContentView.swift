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
                    .frame(width: 200, height: 100)
               
            }
            .frame(height: 300, alignment: .center)
            .overlay(alignment:.bottomTrailing){
                Button {
                   
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
