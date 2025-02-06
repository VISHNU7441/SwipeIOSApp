//
//  PendingProductExtension.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 05/02/25.
//

import Foundation
import SwiftUI

extension PendingProduct {
    func toUploadProduct() -> UploadProduct {
        return UploadProduct(
            tax: self.tax,
            price: self.price,
            productType: self.productType ?? "",
            productName: self.productName ?? "",
            files:self.imageData != nil ? UIImage(data: self.imageData ?? Data()) : nil
        )
    }
}

//self.imageData != nil ? UIImage(data: self.imageData!) : nil
