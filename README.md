# Swipe iOS APP
## Assignment Documentation

This document provides a step-by-step guide to building the iOS assignment using Xcode, Swift, SwiftUI, and Combine. The assignment consists of two main screens: a **Product Listing Screen** and an **Add Product Screen**.

## Table of Contents
1. [Project Setup](#project-setup)
2. [Product Listing Screen](#product-listing-screen)
3. [Add Product Screen](#add-product-screen)
4. [Offline Functionality](#offline-functionality)
5. [API Integration](#api-integration)
6. [Testing](#testing)
7. [Conclusion](#conclusion)

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
##### Update Product List Based on Category
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
##### Add to Favorites
```swift
func updateListOfFavouriteProducts(product: Product) {
    coreDataManager.saveFavouriteProductToCoreData(product: product)
    self.listOfFavouriteProducts = coreDataManager.fetchFavouriteProductFromCoreData()
}
```
##### Remove from Favorites
```swift
func removeProductFromFavouriteList(product: Product) {
    coreDataManager.deleteFavouriteProductFromCoreData(product: product)
    self.listOfFavouriteProducts = coreDataManager.fetchFavouriteProductFromCoreData()
}
```
##### Fetch Favorite Products
```swift
func fetchFavouriteProductList() {
    listOfFavouriteProducts = coreDataManager.fetchFavouriteProductFromCoreData()
}
```
##### Check if Product is in Favorites
```swift
func isThisProductPresentInFavouriteList(product: Product) -> Bool {
    return coreDataManager.isProductAvailableInFavoriteList(product: product)
}
```
#### Search Functionality:
The search feature filters products dynamically and applies debouncing to reduce API calls.

##### Search Products
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
##### Debounce Search Calls
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
##### Connecting the Debounced Search to SwiftUI
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
