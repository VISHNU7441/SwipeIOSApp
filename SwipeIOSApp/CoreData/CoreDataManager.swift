//
//  CoreDataManager.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 05/02/25.
//

import Foundation
import CoreData

class CoreDataManager{
    static let shared = CoreDataManager()
    
    let persistentContainer:NSPersistentContainer
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "UploadProductModel")
        
        persistentContainer.loadPersistentStores { (NsPersistentStoreDescription, error) in
            if let error = error as NSObject?{
                fatalError("Unable to process Core Data due to error:\(error)")
            }
        }
    }
    
    var context:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    
    
    // 1. store the pending products to Core Data
    
    func saveProductToCoreData(product:UploadProduct){
        print("called the save product function")
        let newPendingProduct = PendingProduct(context: context)
        newPendingProduct.tax = product.tax
        newPendingProduct.price = product.price
        newPendingProduct.productName = product.productName
        newPendingProduct.productType = product.productType
        newPendingProduct.imageData = product.files?.jpegData(compressionQuality: 0.8)
        
        do{
            try context.save()
            print("successfully saved to core data")
        }catch{
            print("unable to save the product to CoreData due to error:\(error)")
        }
    }
    
    // 2. fetch the pending products from Core Data
    
    func fetchProductsFromCoreData() -> [UploadProduct]{
        print("call the fetch product func")
        let request:NSFetchRequest<PendingProduct> = PendingProduct.fetchRequest()
        do{
            let result = try context.fetch(request)
            print("successfully fetched")
            return result.map{ $0.toUploadProduct()}
        }
        catch{
            print("Unable to fetch the products from CoreData")
            return []
        }
    }
    
    // 3. delete the pending products from Core Data
    
    func deleteProductsFromCoreData(){
        let request:NSFetchRequest<PendingProduct> = PendingProduct.fetchRequest()
        do{
            let result = try context.fetch(request)
            for pendingProduct in result{
                print("delete in CoreData , product:\(pendingProduct.productName ?? "")")
                context.delete(pendingProduct)
            }
            try context.save()
            print("successfully delete the products.")
        }
        catch{
            print("Unable to delete the products")
        }
    }
    
    func isThereAnyPendingProducts() ->Bool{
        let request:NSFetchRequest<PendingProduct> = PendingProduct.fetchRequest()
        do{
            let result = try context.fetch(request)
            return result.count != 0
            
        }catch{
            print("unable to check the pending products in Core Data")
            return false
        }
    }
    
    // MARK: Handling Favourite Product list
    
    func saveFavouriteProductToCoreData(product:Product){
        let newFavouriteProduct = FavouriteProduct(context: context)
        newFavouriteProduct.image = product.image
        newFavouriteProduct.price = product.price ?? 0
        newFavouriteProduct.productName = product.productName
        newFavouriteProduct.productType = product.productType
        newFavouriteProduct.tax = product.tax ?? 0
        
        do{
            try context.save()
            print("successfully saved FavouriteProduct to core data")
        }catch{
            print("unable to save the FavouriteProduct to CoreData due to error:\(error)")
        }
    }
    
    func fetchFavouriteProductFromCoreData() -> [Product]{
        print("call the fetch product func")
        let request:NSFetchRequest<FavouriteProduct> = FavouriteProduct.fetchRequest()
        do{
            let result = try context.fetch(request)
            print("successfully fetched FavouriteProduct")
            return result.map({$0.toProduct()})
        }
        catch{
            print("Unable to fetch the FavouriteProducts from CoreData")
            return []
        }
    }
    
    func deleteFavouriteProductFromCoreData(product:Product){
        let request:NSFetchRequest<FavouriteProduct> = FavouriteProduct.fetchRequest()
        do{
            let result = try context.fetch(request)
            if let favouriteProductNeedToDelete = result.first(where: {$0.productName == product.productName && $0.price == product.price}){
                context.delete(favouriteProductNeedToDelete)
            }
         
            try context.save()
            print("successfully delete the Favouriteproduct.")
        }
        catch{
            print("Unable to delete the products")
        }
    }
    
    func isProductAvailableInFavoriteList(product:Product) ->Bool{
        let request:NSFetchRequest<FavouriteProduct> = FavouriteProduct.fetchRequest()
        do{
            let result = try context.fetch(request)
            if let _ = result.first(where: {$0.productName == product.productName && $0.price == product.price}){
                return true
            }else{
                return false
            }
        }catch{
            print("unable to check the product available or not")
            return false
        }
    }
    
}
