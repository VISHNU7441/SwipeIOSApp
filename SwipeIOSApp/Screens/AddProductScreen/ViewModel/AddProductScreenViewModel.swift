//
//  AddProductScreenViewModel.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 03/02/25.
//

import Foundation

class AddProductScreenViewModel:ObservableObject{
    
    
    let networkManager = NetworkManager.shared
    
    
//    func upLoadProduct(product:Product){
//        networkManager.uploadData(product: product)
//            .sink { completion in
//                switch completion{
//                case.finished:
//                    print("successfully upload the data")
//                case .failure(let error):
//                    print("unable to upload the data due to error: \(error)")
//                }
//            } receiveValue: { product in
//                print(product)
//            }
//            .store(in: &networkManager.cancellable)
//
//    }
}
