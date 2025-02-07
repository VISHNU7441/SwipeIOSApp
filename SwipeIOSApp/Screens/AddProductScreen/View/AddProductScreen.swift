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
    @State var dataHoldingState = CustomStateHoldingType(productName: "", productType: "")
    @State var inValid:CurrentInvalid = .OK
    @State var isUploadSuccessFul:Bool = false
    @FocusState var currentTextField:ProductFieldFocus?
    var body: some View {
        ScrollView{
            VStack{
                CustomTextField(title: "Product Name", symbol: nil, state: $inValid) {
                    TextField("", text: binding(\.productName))
                        .focused($currentTextField, equals: .productName)
                        .onSubmit {
                            currentTextField = .price
                        }
                }
                CustomTextField(title: "Product Type", symbol: "@", state: $inValid) {
                    HStack{
                        Picker("", selection: binding(\.productType)) {
                            ForEach(ProductType.listOfProductTypes, id: \.self){ productType in
                                Text(productType)
                                    .tag(productType.description)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        Spacer()
                    }
                }
                CustomTextField(title: "Price", symbol: "$", state: $inValid) {
                    TextField("", value: binding(\.price), format: .number)
                        .focused($currentTextField, equals: .price)
                        .onSubmit {
                            currentTextField = .tax
                        }
                }
                CustomTextField(title: "Tax", symbol: "%", state: $inValid) {
                    TextField("", value: binding(\.tax), format: .number)
                        .focused($currentTextField, equals: .tax)
                        .onSubmit {
                          let _ = validateInput()
                        }
                }
                HStack{
                    CustomImagePicker(selectedImage: binding(\.selectedImage))
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
        .sheet(isPresented: $isUploadSuccessFul, onDismiss: {
            dataHoldingState = CustomStateHoldingType(productName: "", productType: "")
        }, content: {
            UploadSuccessScreen(isOnline: .constant(viewModel.isOnline))
        })
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.upLoadProductsFromLocalStorage()
        }
    }
    
    // functions related to view
    
    func validateAndUpload(){
        if validateInput(){
            uploadData()
            isUploadSuccessFul = true
        }
    }
    
    func validateInput() -> Bool{
        guard dataHoldingState.productName.count > 3 else { inValid = .productName ; return false}
        guard !dataHoldingState.productType.isEmpty else { inValid = .productType ; return false}
        guard dataHoldingState.price ?? 0 > 0 else { inValid = .price ; return false}
        guard dataHoldingState.tax ?? 0 > 0 && dataHoldingState.tax ?? 0 < 50 else { inValid = .tax ; return false}
        inValid = .OK
        return true
    }
    
    func uploadData(){
        let newProduct = UploadProduct(
            tax: dataHoldingState.tax ?? 0,
            price: dataHoldingState.price ?? 0,
            productType: dataHoldingState.productType,
            productName: dataHoldingState.productName,
            files: dataHoldingState.selectedImage
        )
        Task{
            await viewModel.upLoadProduct(product: newProduct)
        }
    }
    
    private func binding<T>( _ keyPath:WritableKeyPath<CustomStateHoldingType, T>) -> Binding<T>{
        return Binding(get: {self.dataHoldingState[keyPath: keyPath]},
                       set: {self.dataHoldingState[keyPath: keyPath] = $0})
    }
}


#Preview {
    NavigationStack{
        AddProductScreen()
    }
}

