//
//  UploadSuccessScreen.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 07/02/25.
//

import SwiftUI

struct UploadSuccessScreen: View {
    @Binding var isOnline:Bool
    @State private var isUploadSuccessful:Bool = false
    var body: some View {
        VStack(spacing: 30){
            ZStack{
                Circle()
                    .foregroundStyle(isUploadSuccessful ? .blue.opacity(0.8) : .blue.opacity(0.2))
                    .frame(width: isUploadSuccessful ? 300 : 0)
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isUploadSuccessful ? 90 : 0)
                    .foregroundStyle(isUploadSuccessful ? .white : .blue.opacity(0.2))
            }
            .frame(width: 350, height: 350)
            
            Text(isOnline ? "Upload Successful" : "Internet unavailable! \n product saved locally")
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
                .foregroundStyle(isUploadSuccessful ? .blue.opacity(0.9) : .blue.opacity(0.2))
                .font(.system(size: isUploadSuccessful ? 25 : 0))
               
        }
        .onAppear{
            withAnimation(.easeIn(duration: 0.5)) {
                isUploadSuccessful = true
            }
        }
    }
}

#Preview {
    UploadSuccessScreen(isOnline: .constant(false) )
}
