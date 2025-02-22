# Swipe iOS APP
## Assignment Documentation

This document provides a step-by-step guide to building the iOS assignment using Xcode, Swift, SwiftUI, and Combine. The assignment consists of two main screens: a **Product Listing Screen** and an **Add Product Screen**.

## Table of Contents
1. [Project Setup](#project-setup)
2. [Product Listing Screen](#product-listing-screen)
3. [Add Product Screen](#add-product-screen)
4. [Network Manager](#network-manager)
5. [CoreData Manager](#coredata-manager)
6. [Poject Details](#project-details)


---

## Project Setup

### 1. Create a New Xcode Project
- Open Xcode and select **File > New > Project**.
- Choose **App** under the iOS tab.
- Name your project (e.g., `SwipeAssignment`).
- Select **SwiftUI** as the interface and **Swift** as the language.
- Ensure that **Use Core Data** and **Include Tests** are unchecked (unless needed).

### 2. Set Up Git Repository
- Initialize a Git repository in your project directory:
  ```bash
  git init
## Cloning and Running the Project
### 1. Clone the Repository
To clone the SwipeIOSAPP project from GitHub, follow these steps:

- Open **Terminal** on your Mac.

- Navigate to the directory where you want to clone the project:

 ```bash
cd /path/to/your/directory
```
- Clone the repository using the following command:
```bash
git clone https://github.com/your-username/SwipeIOSAPP.git
```
Replace your-username with your actual GitHub username and ensure the repository is public.

- Once the cloning is complete, navigate into the project directory:

```bash
cd SwipeIOSAPP
```

### 2. Open the Project in Xcode
Open the SwipeIOSAPP.xcodeproj file in Xcode:

```bash
open SwipeIOSAPP.xcodeproj
```
Xcode will load the project. Ensure that the correct Scheme is selected (usually SwipeIOSAPP > My Mac or SwipeIOSAPP > iPhone Simulator).

### 3. Build and Run the Project
- Click the Run button (▶️) in the top-left corner of Xcode, or press Cmd + R.

- Xcode will build the project and launch it in the selected simulator or device.

- If everything is set up correctly, the app should run without errors.

#### Screenshots
<table>
  <tr>
    <td align="center">
<img width="317" alt="home view" src="https://github.com/user-attachments/assets/e3d47787-bd00-4968-9d22-52b07e4f7cf8" />
      <br><em>Home Screen</em>
    </td>
    <td align="center">
      <img width="324" alt="wishlist view" src="https://github.com/user-attachments/assets/c6ad85f3-2d51-4398-91aa-0f7875be7795" />
      <br><em>Listing Product Screen</em>
    </td>
    <td align="center">
<img width="325" alt="cart view" src="https://github.com/user-attachments/assets/5dad265f-817a-413c-87f1-182d105fd213" />
      <br><em>Add Product Screen</em>
    </td>
  </tr>
</table>

## Product Listing Screen

The **Product Listing Screen** displays a grid of available products, categorized by type. It also includes a **Favorites Section** and a **Search Functionality** to enhance the user experience. 

### Features:
- Displays products in a **grid layout** using `LazyVGrid`.
- Shows a **favorites section** if there are saved favorite products.
- Provides a **search overlay** for real-time product filtering.
- Includes a **floating button** to navigate to the "Add Product" screen.

### Code Overview:
The `ListingProductsScreen` is implemented as a SwiftUI `View`, utilizing the **MVVM architecture** through `ListProductScreenViewModel`.

#### Key Components:
- **`@StateObject var viewModel`** – Manages product data and user interactions.
- **`HeaderView()`** – Displays the top navigation or branding section.
- **`FavouriteView(viewModel: viewModel)`** – Shows a section with favorite products.
- **`LazyVGrid(columns: columns)`** – Renders a responsive product grid.
- **`SearchResultView()`** – Displays search results dynamically.
- **`NavigationLink`** – Provides access to the **Add Product Screen**.

#### On Appear:
- `viewModel.updateListOfProducts()` – Fetches the latest list of products.
- `viewModel.fetchFavouriteProductList()` – Loads favorite products.

### Code Snippet:
```swift
struct ListingProductsScreen: View {
    @StateObject var viewModel = ListProductScreenViewModel()
    private let columns: [GridItem] = [GridItem(spacing: 4), GridItem(spacing: 4)]
    
    var body: some View {
        VStack {
            HeaderView()
            ZStack(alignment: .topLeading) {
                ScrollView {
                    VStack {
                        if !viewModel.listOfFavouriteProducts.isEmpty {
                            FavouriteView(viewModel: viewModel)
                        }
                        VStack(alignment: .leading) {
                            Text(viewModel.currentProductType.capitalized)
                                .font(.title3)
                                .bold()
                            
                            LazyVGrid(columns: columns) {
                                ForEach(viewModel.listOfProducts) { product in
                                    ProductCardView(product: product)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.hidden)
                
                if viewModel.isSearching {
                    SearchResultView()
                }
            }
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
        .overlay(alignment: .bottomTrailing) {
            NavigationLink {
                AddProductScreen()
            } label: {
                AddProductButton()
                    .padding(.horizontal)
            }
        }
        .onAppear {
            viewModel.updateListOfProducts()
            viewModel.fetchFavouriteProductList()
        }
        .navigationBarBackButtonHidden()
        .environmentObject(viewModel)
    }
}
```


## Product Listing ViewModel

The `ListProductScreenViewModel` is responsible for managing product data, handling user interactions, and ensuring smooth communication between the UI and data sources.

### Features:
- **Fetches products from the API** using `NetworkManager`.
- **Manages product categories** and updates the product list dynamically.
- **Handles favorites** using `CoreDataManager` for offline storage.
- **Implements a search feature** with debouncing for efficient filtering.

### Code Overview:
The ViewModel follows the **MVVM pattern** and is marked with `@ObservableObject`, making it reactive to UI changes.

#### Properties:
- **`listOfProducts`** – Stores all available products.
- **`listOfFavouriteProducts`** – Stores favorite products fetched from Core Data.
- **`listOfProductType`** – Holds unique product categories.
- **`listOfSearchResults`** – Stores filtered products based on search.
- **`currentProductType`** – Represents the selected category.
- **`isSearching`** – Tracks whether the user is searching.
- **`networkManager`** – Handles API requests.
- **`coreDataManager`** – Manages offline storage using Core Data.
- **`subject`** – Uses `CurrentValueSubject` for debounce-based search execution.

### API Integration:

#### Fetch Products
Fetches all products from the API and updates the list.
```swift
func updateListOfProducts() {
    networkManager.fetchData()
        .sink { completion in
            switch completion {
            case .finished:
                print("Successfully fetched data.")
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        } receiveValue: { [weak self] value in
            self?.listOfProducts = value
            self?.listOfProductType = Array(Set(value.map { $0.productType })).sorted()
            ProductType.listOfProductTypes = self?.listOfProductType ?? []
            self?.currentProductType = self?.listOfProductType.first ?? ""
        }
        .store(in: &networkManager.cancellable)
}
```
#### Update Product List Based on Category 
Filters products based on selected category.
```swift
func updateListView(selectedType: String) {
    currentProductType = selectedType
    networkManager.fetchData()
        .sink { completion in
            switch completion {
            case .finished:
                print("Successfully fetched data.")
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        } receiveValue: { [weak self] value in
            self?.listOfProducts = value.filter { $0.productType == selectedType }
        }
        .store(in: &networkManager.cancellable)
}
```
#### Favorites Management:
Uses Core Data to persist favorite products.
#### Add to Favorites
```swift
func updateListOfFavouriteProducts(product: Product) {
    coreDataManager.saveFavouriteProductToCoreData(product: product)
    self.listOfFavouriteProducts = coreDataManager.fetchFavouriteProductFromCoreData()
}
```
#### Remove from Favorites
```swift
func removeProductFromFavouriteList(product: Product) {
    coreDataManager.deleteFavouriteProductFromCoreData(product: product)
    self.listOfFavouriteProducts = coreDataManager.fetchFavouriteProductFromCoreData()
}
```
#### Fetch Favorite Products
```swift
func fetchFavouriteProductList() {
    listOfFavouriteProducts = coreDataManager.fetchFavouriteProductFromCoreData()
}
```
#### Check if Product is in Favorites
```swift
func isThisProductPresentInFavouriteList(product: Product) -> Bool {
    return coreDataManager.isProductAvailableInFavoriteList(product: product)
}
```
#### Search Functionality:
The search feature filters products dynamically and applies debouncing to reduce API calls.

#### Search Products
```swift
func searchResult(searchTerm: String) {
    networkManager.fetchData()
        .map { products in
            products.filter { $0.productName.lowercased().hasPrefix(searchTerm.lowercased()) }
        }
        .sink { completion in
            switch completion {
            case .finished:
                print("Successfully fetched search results.")
            case .failure(let error):
                print("Error fetching search results: \(error)")
            }
        } receiveValue: { [weak self] results in
            self?.listOfSearchResults = results
        }
        .store(in: &networkManager.cancellable)
}
```
#### Debounce Search Calls
```swift
func callTheSearchFunctionWithDebounce(searchTerm: String) {
    isSearching = !searchTerm.isEmpty
    subject.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        .sink { [weak self] _ in
            self?.searchResult(searchTerm: searchTerm)
        }
        .store(in: &networkManager.cancellable)
}
```

•	Uses subject.debounce() to prevent excessive API calls.
•	Calls searchResult(searchTerm:) after a 0.5-second delay.

#### Connecting the Debounced Search to SwiftUI
In SearchResultView, you need to call callTheSearchFunctionWithDebounce(searchTerm:) whenever the user types.
```swift
TextField("Search products...", text: $searchText)
    .onChange(of: searchText) { newValue in
        viewModel.callTheSearchFunctionWithDebounce(searchTerm: newValue)
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(8)
```

# Add Product Screen

The `AddProductScreen` allows users to add new products by providing details such as **name, type, price, tax, and an image**. It ensures **input validation**, handles **offline storage**, and supports **automatic uploads** when the network is available.

## Features:
- Uploads new products to the server.
- Checks the network connection before performing operations.
- Stores products locally when offline for seamless user experience.
- Fetches and uploads stored products automatically when the network is restored.
- Uses `CoreData` for offline storage.
- Uses `NWPathMonitor` to detect network status.
---

## UI Components:
The `AddProductScreen` is built using SwiftUI and consists of the following elements:

#### 1. *CustomTextField* components 
- **Product Name** (`TextField`)
- **Product Type** (`Picker`)
- **Price** (`TextField` with number format)
- **Tax** (`TextField` with number format)

#### 2. **Image Picker**
- Uses `CustomImagePicker` to allow users to select an image for the product.

#### 3. **Upload Button**
- The **"Upload Product"** button triggers validation and submission.

#### 4. **Toolbar Navigation**
- A **house icon button** allows the user to return to the home screen.
- The **back button is hidden** for a clean navigation experience.

---

## UI Code (SwiftUI)
The UI consists of a `ScrollView` containing various input fields and a button to upload the product.

```swift
import SwiftUI

struct AddProductScreen: View {
    @StateObject var viewModel = AddProductScreenViewModel()
    @Environment(\.dismiss) var dismiss
    @State var dataHoldingState = CustomStateHoldingType(productName: "", productType: "")
    @State var inValid:CurrentInvalid = .OK
    @State var isUploadSuccessFul:Bool = false
    @FocusState var currentTextField:ProductFieldFocus?
    var body: some View {
        ScrollView{
            VStack{
                CustomTextField(title: "Product Name", symbol: nil, state: $inValid) {
                    TextField("", text: binding(\.productName))
                        .focused($currentTextField, equals: .productName)
                        .onSubmit {
                            currentTextField = .price
                        }
                }
                CustomTextField(title: "Product Type", symbol: "@", state: $inValid) {
                    HStack{
                        Picker("", selection: binding(\.productType)) {
                            ForEach(ProductType.listOfProductTypes, id: \.self){ productType in
                                Text(productType)
                                    .tag(productType.description)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        Spacer()
                    }
                }
                CustomTextField(title: "Price", symbol: "$", state: $inValid) {
                    TextField("", value: binding(\.price), format: .number)
                        .focused($currentTextField, equals: .price)
                        .onSubmit {
                            currentTextField = .tax
                        }
                }
                CustomTextField(title: "Tax", symbol: "%", state: $inValid) {
                    TextField("", value: binding(\.tax), format: .number)
                        .focused($currentTextField, equals: .tax)
                        .onSubmit {
                          let _ = validateInput()
                        }
                }
                HStack{
                    CustomImagePicker(selectedImage: binding(\.selectedImage))
                    Spacer()
                }
            
                Button("Upload Product") {
                    validateAndUpload()
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
               
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Add Product")
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "house")
                }

            }
        }
        .sheet(isPresented: $isUploadSuccessFul, onDismiss: {
            dataHoldingState = CustomStateHoldingType(productName: "", productType: "")
        }, content: {
            UploadSuccessScreen(isOnline: .constant(viewModel.isOnline))
        })
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.upLoadProductsFromLocalStorage()
        }
    }
    
    // functions related to view
    
    func validateAndUpload(){
        if validateInput(){
            uploadData()
            isUploadSuccessFul = true
        }
    }
    
    func validateInput() -> Bool{
        guard dataHoldingState.productName.count > 3 else { inValid = .productName ; return false}
        guard !dataHoldingState.productType.isEmpty else { inValid = .productType ; return false}
        guard dataHoldingState.price ?? 0 > 0 else { inValid = .price ; return false}
        guard dataHoldingState.tax ?? 0 > 0 && dataHoldingState.tax ?? 0 < 50 else { inValid = .tax ; return false}
        inValid = .OK
        return true
    }
    
    func uploadData(){
        let newProduct = UploadProduct(
            tax: dataHoldingState.tax ?? 0,
            price: dataHoldingState.price ?? 0,
            productType: dataHoldingState.productType,
            productName: dataHoldingState.productName,
            files: dataHoldingState.selectedImage
        )
        Task{
            await viewModel.upLoadProduct(product: newProduct)
        }
    }
    
    private func binding<T>( _ keyPath:WritableKeyPath<CustomStateHoldingType, T>) -> Binding<T>{
        return Binding(get: {self.dataHoldingState[keyPath: keyPath]},
                       set: {self.dataHoldingState[keyPath: keyPath] = $0})
    }
}
```
## AddProduct Screen ViewModel

The `AddProductScreenViewModel` is responsible for managing product uploads, handling network status, and syncing stored data.

### **Responsibilities:**
- **Product uploads:** Sends product data to the server when online.
- **Checking the network connection:** Monitors internet availability using `NWPathMonitor`.
- **Storing products locally when offline:** Uses `CoreDataManager` to store products if there is no internet.
- **Fetching and uploading stored products when online:** Retrieves unsynced products and uploads them automatically when a connection is restored.

### **Key Functions:**
#### 1. **upLoadProduct(product:)**
- Uploads a product if the device is online.
- Stores the product in local storage if offline.
  ```swift
  func upLoadProduct(product:UploadProduct) async{
        if isOnline{
            await networkManager.uploadProduct(product)
        }else{
            print("no internet connection:\(isOnline.description)")
            storeTheProductOffline(product: product)
            self.isAnyProductStoredLocally = true
        }
    }
  ```

#### 2. **storeTheProductOffline(product:)**
- Saves product details to Core Data when there is no internet.
  ```swift
  func storeTheProductOffline(product:UploadProduct){
        coreDataManager.saveProductToCoreData(product: product)
    }
  ```
#### 3. **setUpTheNetworkMonitor()**
- Uses `NWPathMonitor` to detect internet connection status in real-time.
  ```swift
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
  ```
#### 4. **upLoadProductsFromLocalStorage()**
- Fetches products stored in Core Data.
- Uploads them when the internet is available.
  ```swift
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
  ```
#### 5. **fetchTheProductsFromLocal()**
- Retrieves stored products from Core Data.
- Deletes them after a successful upload.
- Updates the flag for pending products.
 ```swift
 func fetchTheProductsFromLocal() -> [UploadProduct]{
        let fetchedProducts = coreDataManager.fetchProductsFromCoreData() // a) will fetch the product
        print(fetchedProducts.first?.productName as Any)
        
        coreDataManager.deleteProductsFromCoreData() // b) delete the product
        
        isThereAnyPendingProducts = coreDataManager.isThereAnyPendingProducts()
        return fetchedProducts
    }
 ```
---

## Usage Flow:
1. **User enters product details** in the input fields.
2. **User selects an image** using the image picker.
3. **Upon tapping "Upload Product"**, the app:<br>
 a) Validates the input fields.<br>
 b) Checks the network status<br>
 c) If **online**, uploads the product directly.<br>
 d) If **offline**, stores the product locally for later syncing.<br>
4. When the internet is restored, **stored products are automatically uploaded**.

---

### Code Overview:
The ViewModel follows the **MVVM pattern** and is marked with `@ObservableObject`, making it reactive to UI changes.

#### Properties:
- **`networkManager`** – Handles API requests for uploading products.
- **`coreDataManager`** – Manages offline storage using Core Data.
- **`monitor`** – Uses `NWPathMonitor` to track internet connectivity status.
- **`isOnline`** – Tracks whether the user is online.
- **`isAnyProductStoredLocally`** –  Indicates whether any products are stored offline.
- **`isThereAnyPendingProducts`** –  Checks for pending products that need to be uploaded..


### Network Monitoring:

The ViewModel monitors network connectivity and updates isOnline accordingly.
```swift
private func setUpTheNetworkMonitor() {
    monitor.pathUpdateHandler = { path in
        DispatchQueue.main.async {
            self.isOnline = path.status == .satisfied
        }
    }
    let queue = DispatchQueue(label: "Network Monitor")
    monitor.start(queue: queue)
    print(isOnline.description)
}
```
- Uses `NWPathMonitor` to track internet status.
- Updates `isOnline` property when the connection status changes.

### API Integration:
  
#### Update Product  
Uploads a product if the internet is available; otherwise, stores it locally.
```swift
func upLoadProduct(product: UploadProduct) async {
    if isOnline {
        await networkManager.uploadProduct(product)
    } else {
        print("No internet connection: \(isOnline.description)")
        storeTheProductOffline(product: product)
        self.isAnyProductStoredLocally = true
    }
}
```
- If `isOnline` is true, uploads the product via `networkManager`
- If offline, stores the product in Core Data for later upload.

#### Store Product Offline 
Saves the product locally in Core Data for future synchronization
```swift
func storeTheProductOffline(product: UploadProduct) {
    coreDataManager.saveProductToCoreData(product: product)
}
```
- Uses coreDataManager to persist product data when offline.


#### Upload Pending Products from Local Storage
Attempts to upload locally stored products when the internet is available.
```swift
func upLoadProductsFromLocalStorage() async {
    if isOnline && (isAnyProductStoredLocally || isThereAnyPendingProducts) {
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
    print("isAnyProductStoredLocally: \(isAnyProductStoredLocally.description) && isThereAnyPendingProducts: \(isThereAnyPendingProducts.description)")
}
```
- Fetches products from local storage.
- Uses `withTaskGroup` to upload them concurrently.
- Updates `isAnyProductStoredLocally` after successful uploads.

#### Fetching and Deleting Local Products:
Retrieves and removes stored products from Core Data.
```swift
private func fetchTheProductsFromLocal() -> [UploadProduct] {
    let fetchedProducts = coreDataManager.fetchProductsFromCoreData()
    print(fetchedProducts.first?.productName as Any)
    
    coreDataManager.deleteProductsFromCoreData()
    isThereAnyPendingProducts = coreDataManager.isThereAnyPendingProducts()
    return fetchedProducts
}
```
- Fetches stored products from Core Data.
- Deletes them after fetching.
- Updates `isThereAnyPendingProducts` accordingly.

## Network Manager

## Overview
`NetworkManager` is a singleton class responsible for handling network requests, including fetching product data and uploading product details with an optional image to a server. It uses `Combine` for handling asynchronous data fetching and Swift concurrency (`async/await`) for uploading data.

## Features
- Fetches product data from the API.
- Uploads product data with multipart/form-data support.
- Uses `Combine` for fetching operations.
- Uses `async/await` for upload operations.
- Handles JSON decoding and error management.

### Implementation

#### Singleton Instance
```swift
static let shared = NetworkManager()
```
This ensures that there is a single shared instance of `NetworkManager` throughout the app.

##### Dependencies
```swift
import Foundation
import Combine
```
The class uses `Foundation` for networking and `Combine` for reactive programming.

### Properties

#### baseURL
```swift
let baseURL = "https://app.getswipe.in/api/public/"
```
Defines the base URL for API requests.

#### cancellable
```swift
var cancellable = Set<AnyCancellable>()
```
Stores Combine subscriptions to manage memory efficiently.

### Methods

#### 1) fetchData()
Fetches an array of `Product` objects from the API.

##### Definition
```swift
func fetchData() -> AnyPublisher<[Product], Error>
```

##### Implementation
```swift
let publisher = URLSession.shared.dataTaskPublisher(for: url)
    .map(\.data)
    .decode(type: [Product].self, decoder: JSONDecoder())
    .map{ value in
        print(value.count)
        return value
    }
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
```

##### Usage
```swift
NetworkManager.shared.fetchData()
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Fetch successful")
        case .failure(let error):
            print("Fetch failed: \(error)")
        }
    }, receiveValue: { products in
        print("Received \(products.count) products")
    })
    .store(in: &NetworkManager.shared.cancellable)
```

---

#### 2) uploadProduct(_:)
Uploads product details, including an optional image, using `multipart/form-data`.

##### Definition
```swift
func uploadProduct(_ product: UploadProduct) async
```

##### Implementation
```swift
let (data, response) = try await URLSession.shared.upload(for: request, from: body)
```
Handles the network request asynchronously using Swift's `async/await`.

##### Usage
```swift
Task {
    await NetworkManager.shared.uploadProduct(uploadProductInstance)
}
```

---

#### 3) createFormDataBody(product:boundary:)
Creates the multipart form-data body for uploading products.

##### Definition
```swift
private func createFormDataBody(product: UploadProduct, boundary: String) -> Data
```

##### Implementation
```swift
let parameters: [String: String] = [
    "product_name": product.productName,
    "product_type": product.productType,
    "price": String(product.price),
    "tax": String(product.tax)
]
```
Loops through the dictionary and appends key-value pairs as form data.

---

## Data Models

### Product
```swift
struct Product: Codable {
    let id: Int
    let name: String
    let price: Double
    let tax: Double
}
```

### UploadProduct
```swift
struct UploadProduct {
    let productName: String
    let productType: String
    let price: Double
    let tax: Double
    let files: UIImage?
}
```

### Error Handling
- If the URL is invalid, an error message is printed.
- If the network request fails, the error is caught and printed.

## CoreData Manager

## Overview
The `CoreDataManager` class is responsible for managing Core Data operations, including saving, fetching, and deleting `UploadProduct` and `FavouriteProduct` entities.

## Features
- Saves pending products to Core Data
- Fetches pending products from Core Data
- Deletes pending products from Core Data
- Checks if there are any pending products
- Saves, fetches, and deletes favorite products
- Checks if a product is in the favorite list

#### Singleton Instance
The `CoreDataManager` follows the Singleton pattern, ensuring that only one instance of the class exists.

```swift
static let shared = CoreDataManager()
```

### Properties

#### persistentContainer
A `NSPersistentContainer` instance responsible for managing the Core Data stack.

#### context
Provides access to `NSManagedObjectContext`, used for performing operations on Core Data entities.

```swift
var context: NSManagedObjectContext {
    return persistentContainer.viewContext
}
```

### Methods

#### 1) saveProductToCoreData(product: UploadProduct)
Saves a `UploadProduct` instance to Core Data as a `PendingProduct`.

```swift
 func saveProductToCoreData(product:UploadProduct){
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

```

#### 2) fetchProductsFromCoreData() -> [UploadProduct]
Fetches all `PendingProduct` entities and converts them to `UploadProduct` instances.

```swift
func fetchProductsFromCoreData() -> [UploadProduct]{
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


```

#### 3) deleteProductsFromCoreData()
Deletes all pending products stored in Core Data.

```swift
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


```

#### 4) isThereAnyPendingProducts() -> Bool
Checks if there are any pending products in Core Data.

```swift
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


```

### Handling Favorite Products

#### 5) saveFavouriteProductToCoreData(product: Product)
Saves a `Product` as a favorite in Core Data.

```swift
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
```

#### 6) fetchFavouriteProductFromCoreData() -> [Product]
Fetches all favorite products stored in Core Data.

```swift
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
```

#### 7) deleteFavouriteProductFromCoreData(product: Product)
Deletes a specific favorite product from Core Data.

```swift
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
```

#### 8) isProductAvailableInFavoriteList(product: Product) -> Bool
Checks if a product exists in the favorite list.

```swift
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
```

### Error Handling
The class includes error handling mechanisms, printing error messages if operations fail:

```swift
catch {
    print("Unable to fetch the products from CoreData")
    return []
}
```

#### Project Details
* App Name: SwipeIOSApp
* Version: 1.0.0
* Author: Vishnu R S

#### Contact
* Email: vishnurs74417441@gmail.com
* LinkedIn: [linkedin.com/in/vishnurs7441](https://www.linkedin.com/in/vishnurs7441)
* GitHub: [github.com/vishnu7441](https://www.github.com/vishnu7441)



