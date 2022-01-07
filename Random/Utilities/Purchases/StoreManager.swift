//
//  StoreManager.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation
import StoreKit

final class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published var myProducts = [SKProduct]()
    @Published var transactionState: SKPaymentTransactionState?
    @Published var showActivityIndicator = false
    var request: SKProductsRequest!
    
    var statePurchase: ((Bool) -> Void)?
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive response")
        
        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                }
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if queue.transactions.isEmpty {
            statePurchase?(false)
            showActivityIndicator = false
        }
    }
    
    // эта функция вызывается каждый раз, когда что-то меняется в статусе транзакции (транзакций), обрабатываемой в данный момент.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                statePurchase?(true)
                queue.finishTransaction(transaction)
                transactionState = .purchased
                showActivityIndicator = false
            case .restored:
                statePurchase?(true)
                queue.finishTransaction(transaction)
                transactionState = .restored
                showActivityIndicator = false
            case .failed, .deferred:
                transactionState = .failed
                print("\(String(describing: transaction.error))")
                showActivityIndicator = false
            @unknown default:
                queue.finishTransaction(transaction)
                showActivityIndicator = false
            }
        }
    }
    
    // Чтобы начать транзакцию, мы реализуем новую функцию под названием «PurchaseProducts», которая принимает SKProduct.
    func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            alert(NSLocalizedString("Пользователь не может произвести оплату", comment: ""))
        }
    }
    
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

private extension StoreManager {
    func alert(_ message: String) {
        UIApplication.shared.windows.first?.rootViewController?
            .showAlert(with: NSLocalizedString("Ошибка", comment: ""), and: message, style: .alert)
    }
}
