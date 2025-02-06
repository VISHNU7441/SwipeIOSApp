//
//  CustomImagePicker.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 04/02/25.
//

import SwiftUI
import PhotosUI

struct CustomImagePicker: View {
    @Binding var selectedImage: UIImage?
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .overlay {
                        Image(systemName: "photo.on.rectangle")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
            }

            PhotosPicker("Choose Image", selection: $pickerItem, matching: .images)
                .onChange(of: pickerItem) { _, newValue in
                    loadImage(from: newValue)
                }
        }
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }

        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let imageData?) = result,
                   let image = UIImage(data: imageData) {
                    self.selectedImage = cropToSquare(image)
                }
            }
        }
    }

    private func cropToSquare(_ image: UIImage) -> UIImage {
        let minLength = min(image.size.width, image.size.height)
        let cropRect = CGRect(
            x: (image.size.width - minLength) / 2,
            y: (image.size.height - minLength) / 2,
            width: minLength,
            height: minLength
        )

        if let cgImage = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        }
        return image
    }
}


