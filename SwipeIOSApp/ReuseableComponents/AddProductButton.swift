//
//  AddProductButton.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 05/02/25.
//

import SwiftUI

struct AddProductButton: View {
    var body: some View {
        Circle()
            .fill(.swipeButtonColour)
            .frame(width: 70)
            .overlay {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .font(.title2)
                    .foregroundStyle(.white)
            }
    }
}

#Preview {
    AddProductButton()
}
