//
//  CustomTextField.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 04/02/25.
//

import SwiftUI

struct CustomTextField<Content:View>: View {
    let title:String
    let symbol:String?
    @Binding var state:CurrentInvalid
    let content: () -> Content
    var body: some View {
        VStack(alignment:.leading){
            Text(title)
                .foregroundStyle(.secondary)
            ZStack{
                HStack{
                    Text(symbol ?? "")
                        .foregroundStyle(.swipeButtonColour)
                    content()
                }
            }
            .frame(minHeight: 30)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder( )
                .foregroundStyle(state.rawValue == title ? Color.red : .swipeButtonColour)
        )
    }
}



