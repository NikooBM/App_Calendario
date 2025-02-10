import StoreKit

class StoreKitService {
    private var subscriptions: [Product] = []
    
    init() {
        Task {
            await loadProducts()
        }
    }
    
    private func loadProducts() async {
        do {
            let products = try await Product.products(for: ["com.app.calendar.premium.monthly",
                                                          "com.app.calendar.premium.yearly"])
            subscriptions = products
        } catch {
            print("Error loading products: \(error)")
        }
    }
    
    func purchaseSubscription() async throws {
        guard let product = subscriptions.first else {
            throw StoreError.productNotFound
        }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
        case .userCancelled:
            throw StoreError.userCancelled
        case .pending:
            throw StoreError.pending
        @unknown default:
            throw StoreError.unknown
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
    
    enum StoreError: Error {
        case productNotFound
        case userCancelled
        case verificationFailed
        case pending
        case unknown
    }
} 