//
//  AddProductScreenViewModel.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 03/02/25.
//

import Foundation
import Network

class AddProductScreenViewModel:ObservableObject{
    
    private let networkManager = NetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    private let monitor = NWPathMonitor()
    @Published var isOnline:Bool = true
    var isAnyProductStoredLocally:Bool = false
    var isThereAnyPendingProducts:Bool = true
    
    init(){
        setUpTheNetworkMonitor()
    }
    // Setup the network for monitor the internet connection
    private func setUpTheNetworkMonitor(){
         monitor.pathUpdateHandler = { path in
             DispatchQueue.main.async {
                 self.isOnline = path.status == .satisfied  // update the network status
             }
         }
        let queue = DispatchQueue(label: "Network Monitor")
        monitor.start(queue: queue)
        print(isOnline.description)
     }
    
    // Main function to upload product
    func upLoadProduct(product:UploadProduct) async{
        if isOnline{
            await networkManager.uploadProduct(product)
        }else{
            print("no internet connection:\(isOnline.description)")
            storeTheProductOffline(product: product)
            self.isAnyProductStoredLocally = true
        }
    }
    
    
    func storeTheProductOffline(product:UploadProduct){
        coreDataManager.saveProductToCoreData(product: product)
    }
    

    func upLoadProductsFromLocalStorage() async{
        if isOnline && (isAnyProductStoredLocally || isThereAnyPendingProducts){
            let productsFromLocal = fetchTheProductsFromLocal()
            
            await withTaskGroup(of: Void.self) { group in
                for product in productsFromLocal {
                    group.addTask {
                        await self.networkManager.uploadProduct(product)
                        print("Product: \(product) from local uploaded successfully")
                    }
                }
            }
        }
        isAnyProductStoredLocally = false
        print("isAnyProductsStoredLocally:\(isAnyProductStoredLocally.description) && isThereAnyPendingProducts:\(isThereAnyPendingProducts.description)")
    }
    
    private func fetchTheProductsFromLocal() -> [UploadProduct]{
        let fetchedProducts = coreDataManager.fetchProductsFromCoreData() // a) will fetch the product
        print(fetchedProducts.first?.productName as Any)
        
        coreDataManager.deleteProductsFromCoreData() // b) delete the product
        
        isThereAnyPendingProducts = coreDataManager.isThereAnyPendingProducts()
        return fetchedProducts
    }
    
    
 
}
