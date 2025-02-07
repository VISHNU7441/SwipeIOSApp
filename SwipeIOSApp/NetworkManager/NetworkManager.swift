//
//  NetworkManager.swift
//  SwipeIOSApp
//
//  Created by vishnu r s on 31/01/25.
//

import Foundation
import Combine

class NetworkManager{
    static let shared = NetworkManager()
    
    var cancellable = Set<AnyCancellable>()
    private init(){
        
    }
    let baseURL = "https://app.getswipe.in/api/public/"
    

    
    func fetchData() -> AnyPublisher<[Product], Error>{
        guard let url = URL(string:"\(baseURL)get") else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher()}
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Product].self, decoder: JSONDecoder())
            .map{ value in
                print(value.count)
                return value
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        return publisher
    }
    
   
        
        func uploadProduct(_ product: UploadProduct) async {
            print("calling upload function in network")
            guard let url = URL(string: "\(baseURL)add") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            let body = createFormDataBody(product: product, boundary: boundary)

            do {
                print("now trying to upload")
                let (data, response) = try await URLSession.shared.upload(for: request, from: body)

                if let httpResponse = response as? HTTPURLResponse {
                    print("Response Code: \(httpResponse.statusCode)")
                }

                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }

                print("Upload Success")
            } catch {
                print("Upload failed with error: \(error)")
            }
        }

        // Creates the multipart/form-data body
        private func createFormDataBody(product: UploadProduct, boundary: String) -> Data {
            var body = Data()
            
            let parameters: [String: String] = [
                "product_name": product.productName,
                "product_type": product.productType,
                "price": String(product.price),
                "tax": String(product.tax)
            ]

            for (key, value) in parameters {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
            
            // Append image if available
            if let image = product.files, let imageData = image.jpegData(compressionQuality: 0.8) {
                let filename = "uploaded_image.jpg"
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }

            // Closing boundary
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            return body
        }
    
}
