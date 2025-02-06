//
//  AddproductScreen.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 03/02/25.
//

import SwiftUI

struct AddProductScreen: View {
    @Environment(\.dismiss) var dismiss
    @State var productName:String = ""
    @State var price:Int?
    @State var tax:Int?
    @State var productType:String = ProductType.listOfProductTypes.first ?? ""
    @State var selectedImage: UIImage?
    var body: some View {
        VStack{
            CustomTextField(title: "Product Name", symbol: nil) { TextField("", text: $productName) }
            CustomTextField(title: "", symbol: "@") {
                HStack{
                    Picker("Product Type", selection: $productType) {
                        ForEach(ProductType.listOfProductTypes, id: \.self){ productType in
                            Text(productType)
                                .tag(productType.description)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    Spacer()
                }
            } // picker view
            CustomTextField(title: "Price", symbol: "$") { TextField("", value: $price, format: .number)}
            CustomTextField(title: "Tax", symbol: "%") { TextField("", value: $tax, format: .number) }
            HStack{
                CustomImagePicker(selectedImage: $selectedImage)
                Spacer()
            }
            Spacer()
            Button("Upload Product") {
                dismiss()
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
    
        }
        .padding()
        .navigationTitle("Add Product")
        .navigationBarBackButtonHidden()
    }
    
}


#Preview {
    NavigationStack{
        SampleScreen()
    }
}

