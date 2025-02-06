//
//  ListProductScreenViewModel.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import Foundation
import Combine


class ListProductScreenViewModel:ObservableObject{
    @Published var listOfProducts:[Product] = []
    @Published var listOfFavouriteProducts:[Product] = []
    @Published var listOfProductType:[String] = []
    @Published var listOfSearchResults:[Product] = []
    @Published var currentProductType:String  = ""
    @Published var isSearching:Bool = false
    private let networkManager = NetworkManager.shared
    private let coreDataManger = CoreDataManager.shared
    private var subject = CurrentValueSubject<String, Never>("")
    
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
                ProductType.listOfProductTypes = self?.listOfProductType ?? []
                self?.currentProductType = self?.listOfProductType[0] ?? ""
            }
            .store(in: &networkManager.cancellable)

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
  
    
    // MARK: Functions for handling favourite products.
    
    func updateListOfFavouriteProducts(product:Product){
      //  listOfFavouriteProducts.append(product)
        coreDataManger.saveFavouriteProductToCoreData(product: product)
        self.listOfFavouriteProducts = coreDataManger.fetchFavouriteProductFromCoreData()
    }
    
    func removeProductFromFavouriteList(product:Product){
      //  listOfFavouriteProducts.removeAll(where: {$0.id == product.id})
        coreDataManger.deleteFavouriteProductFromCoreData(product: product)
        self.listOfFavouriteProducts = coreDataManger.fetchFavouriteProductFromCoreData()
    }
    
    func fetchFavouriteProductList(){
        listOfFavouriteProducts = coreDataManger.fetchFavouriteProductFromCoreData()
    }
    
    func isThisProductPresentInFavouriteList(product:Product) -> Bool{
        return coreDataManger.isProductAvailableInFavoriteList(product: product)
    }
    
    
    // MARK: Functions for search function.
    
    func searchResult(searchTerm:String){
        networkManager.fetchData()
            .map{ products in
                products.filter{ $0.productName.lowercased().hasPrefix(searchTerm.lowercased())}
            }
            .sink { completion in
                switch completion{
                case .finished:
                    print("successfully fetched the search results")
                case .failure(let error):
                    print("unable to fetch the results due to error:\(error)")
                }
            } receiveValue: {[weak self] results in
                self?.listOfSearchResults = results
            }
            .store(in: &networkManager.cancellable)
    }
    
    func callTheSearchFunctionWithDebounce(searchTerm:String){
        isSearching = true
        if searchTerm == ""{
            isSearching = false
        }
        subject.debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.searchResult(searchTerm: searchTerm)
            }
            .store(in: &networkManager.cancellable)
    }
    
    
    
}
