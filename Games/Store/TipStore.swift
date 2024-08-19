//
//  TipStore.swift
//  GoodGames
//
//  Created by Ali Dinc on 16/02/2023.
//

import StoreKit
import SwiftUI
import Observation

let myTipProductIdentifiers = [
    "com.alidinc.Games.tinyTip",
    "com.alidinc.Games.mediumTip",
    "com.alidinc.Games.largeTip"
]

enum TipsAction: Equatable {
    case successful
    case failed(TipsError)
    
    static func == (lhs: TipsAction, rhs: TipsAction) -> Bool {
        switch (lhs, rhs) {
        case (.successful, .successful):
            return true
        case (let .failed(lhsErr), let .failed(rhsErr)):
            return lhsErr.localizedDescription == rhsErr.localizedDescription
        default:
            return false
        }
    }
}

typealias PurchaseResult = Product.PurchaseResult
typealias TransactionListener = Task<Void, Error>


@Observable
final class TipStore {

    var isLoading = false

	init() {
        self.transactionListener = self.configureTransactionListener()
        
        Task { [weak self] in
            await self?.retrieveProducts()
        }
    }
    
    deinit {
        self.transactionListener?.cancel()
    }
    
   private(set) var items = [Product]()
	
   private(set) var action: TipsAction? {
        didSet {
            switch self.action {
            case .failed:
                self.hasError = true
            default:
                self.hasError = false
            }
        }
    }
    
	var hasError = false
    
    var error: TipsError? {
        switch self.action {
        case .failed(let error):
            return error
        default:
            return nil
        }
    }
    
    private var transactionListener: TransactionListener?
    
    func purchase(_ item: Product) async {
        self.isLoading = true

        do {
            let result = try await item.purchase()
            try await self.handlePurchase(from: result)
            self.isLoading = false
        } catch {
            DispatchQueue.main.async {
                self.action = .failed(.system(error))
            }
        }
    }

    func reset() {
        self.action = nil
    }
}

private extension TipStore {
    
    func configureTransactionListener() -> TransactionListener {
        Task.detached(priority: .background) { @MainActor [weak self] in
            do {
                for await result in Transaction.updates {
                    let transaction = try self?.checkVerified(result)
                    self?.action = .successful
                    await transaction?.finish()
                }
            } catch {
				DispatchQueue.main.async {
					self?.action = .failed(.system(error))
				}
            }
        }
    }

	@MainActor
    func retrieveProducts() async {
        do {
            let products = try await Product.products(for: myTipProductIdentifiers)
            self.items = products.sorted(by: { $0.price < $1.price })
        } catch {
			DispatchQueue.main.async {
				self.action = .failed(.system(error))
			}
        }
    }
    
    func handlePurchase(from result: PurchaseResult) async throws {
        switch result {
        case .success(let verification):
            print("Purchase was a success, now it's time to verify their purchase")
            let transaction = try checkVerified(verification)
            
            self.action = .successful
            
            await transaction.finish()
            
        case .pending:
            print("The user needs to complete some action on their account before they can complete purchase")
            
        case .userCancelled:
            print("The user hit cancel before their transaction started")
            
        default:
            print("Unknown error")
        }
    }
    
    /// Check if the user is verified with their purchase
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            print("The verification of the user failed")
            throw TipsError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}
