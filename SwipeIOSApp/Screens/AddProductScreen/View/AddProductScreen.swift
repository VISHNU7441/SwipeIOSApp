//
//  AddProductScreen.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 03/02/25.
//

import SwiftUI

struct AddProductScreen: View {
    @StateObject var viewModel = AddProductScreenViewModel()
    @Environment(\.dismiss) var dismiss
    @State var productName:String = ""
    @State var price:Int16?
    @State var tax:Int16?
    @State var productType:String = ProductType.listOfProductTypes.first ?? ""
    @State var selectedImage: UIImage?
    @State var inValid:CurrentInvalid = .OK
    @FocusState var currentTextField:ProductFieldFocus?
    var body: some View {
        ScrollView{
            VStack{
                CustomTextField(title: "Product Name", symbol: nil, state: $inValid) {
                    TextField("", text: $productName)
                        .focused($currentTextField, equals: .productName)
                        .onSubmit {
                            currentTextField = .price
                        }
                }
                CustomTextField(title: "Product Type", symbol: "@", state: $inValid) {
                    HStack{
                        Picker("", selection: $productType) {
                            ForEach(ProductType.listOfProductTypes, id: \.self){ productType in
                                Text(productType)
                                    .tag(productType.description)
                            }
                        }
                        
                        .pickerStyle(.navigationLink)
                        Spacer()
                    }
                } // picker view
                CustomTextField(title: "Price", symbol: "$", state: $inValid) {
                    TextField("", value: $price, format: .number)
                        .focused($currentTextField, equals: .price)
                        .onSubmit {
                            currentTextField = .tax
                        }
                }
                CustomTextField(title: "Tax", symbol: "%", state: $inValid) {
                    TextField("", value: $tax, format: .number)
                        .focused($currentTextField, equals: .tax)
                        .onSubmit {
                          let _ = validateInput()
                        }
                }
                HStack{
                    CustomImagePicker(selectedImage: $selectedImage)
                    Spacer()
                }
            
                Button("Upload Product") {
                    validateAndUpload()
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
               
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Add Product")
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "house")
                }

            }
        }
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.upLoadProductsFromLocalStorage()
        }
    }
    
    func validateAndUpload(){
        if validateInput(){
            uploadData()
        }
    }
    
    func validateInput() -> Bool{
        guard productName.count > 3 else { inValid = .productName ; return false}
        guard !productType.isEmpty else { inValid = .productType ; return false}
        guard price ?? 0 > 0 else { inValid = .price ; return false}
        guard tax ?? 0 > 0 && tax ?? 0 < 50 else { inValid = .tax ; return false}
        inValid = .OK
        return true
    }
    
    func uploadData(){
        let newProduct = UploadProduct(
            tax: tax ?? 0,
            price: price ?? 0,
            productType: productType,
            productName: productName,
            files: selectedImage
        )
        Task{
            await viewModel.upLoadProduct(product: newProduct)
        }
    }
    
}


#Preview {
    NavigationStack{
        AddProductScreen()
    }
}


