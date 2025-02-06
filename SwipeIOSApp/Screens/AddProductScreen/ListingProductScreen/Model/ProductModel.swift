//
//  ProductModel.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import Foundation

struct Product:Identifiable, Codable{
    let id = UUID().uuidString
    let image:String?
    let price:Double?
    let productName:String
    let productType:String
    let tax:Double?

    
    enum CodingKeys: String, CodingKey{
        case image, price, tax
        case productName = "product_name"
        case productType = "product_type"
    }
    
    static var sampleData = Product(image: "https://vx-erp-product-images.s3.ap-south-1.amazonaws.com/9_1738313090_0_product.jpg",
                                    price: 5800,
                                    productName: "Ofline test 2 ",
                                    productType: "Product",
                                    tax: 10)
}

/*
 {
     "image": "",
     "price": 100,
     "product_name": "test11",
     "product_type": "test",
     "tax": 5
   },
 */
