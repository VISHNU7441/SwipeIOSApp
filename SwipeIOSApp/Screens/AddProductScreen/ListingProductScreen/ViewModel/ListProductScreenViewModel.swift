//
//  ListProductScreenViewModel.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import Foundation
import SwiftUI

class ListProductScreenViewModel:ObservableObject{
    @Published var listOfProducts:[Product] = []
    @Published var listOfFavouriteProducts:[Product] = []
    @Published var listOfProductType:[String] = []
    @Published var currentProductType:String  = ""
    let networkManager = NetworkManager.shared
    
    func updateListOfProducts(){
        networkManager.fetchData()
            .sink { completion in
                switch completion{
                case .finished:
                    print("successfully fetched data. ")
                case .failure(let error):
                    print("unable to fetch data due the error:\(error)")
                }
            } receiveValue: {[weak self] value in
                self?.listOfProducts = value
                self?.listOfProductType = Array(Set(value.map { $0.productType })).sorted()
                self?.currentProductType = self?.listOfProductType[0] ?? ""
            }
            .store(in: &networkManager.cancellable)

    }
    
    
    func updateListOfFavouriteProducts(product:Product){
        listOfFavouriteProducts.append(product)
    }
    
    func removeProductFromFavouriteList(product:Product){
        listOfFavouriteProducts.removeAll(where: {$0.id == product.id})
    }
    
    func updateListView(selectedType:String){
        currentProductType = selectedType
        networkManager.fetchData()
            .sink { completion in
                switch completion{
                case .finished:
                    print("successfully fetched data. ")
                case .failure(let error):
                    print("unable to fetch data due the error:\(error)")
                }
            } receiveValue: {[weak self] value in
                self?.listOfProducts = value.filter{ $0.productType == selectedType}
            }
            .store(in: &networkManager.cancellable)
    }
}
