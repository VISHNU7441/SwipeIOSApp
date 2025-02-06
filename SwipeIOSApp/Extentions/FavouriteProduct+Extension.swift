//
//  FavouriteProductExtension.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 06/02/25.
//
import Foundation

extension FavouriteProduct {
    func toProduct() -> Product {
        return Product(
            image: self.image,
            price: self.price,
            productName: self.productName ?? "",
            productType: self.productType ?? "",
            tax: self.tax
        )
    }
}
