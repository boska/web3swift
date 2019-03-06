//  web3swift
//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt
import PromiseKit

/// Global namespace containing API for an web3 instance bound to provider. All further functionality is provided under web.*. namespaces.
public class web3 {
    /// Provider for instance
    public var provider : Web3Provider
    
    /// Transaction options for instance
    public var transactionOptions: TransactionOptions = TransactionOptions.defaultOptions
    
    /// Default block for instance
    public var defaultBlock = "latest"
    
    /// Dispatcher for JSON RPC requests
    public var requestDispatcher: JSONRPCrequestDispatcher
    
    /// Add a provider request to the dispatch queue.
    ///
    /// - Parameter request: JSON RPC request
    /// - Returns: promise of JSON RPC response
    public func dispatch(_ request: JSONRPCrequest) -> Promise<JSONRPCresponse> {
        return self.requestDispatcher.addToQueue(request: request)
    }

    /// Raw initializer using a Web3Provider protocol object, dispatch queue and request dispatcher.
    ///
    /// - Parameters:
    ///   - prov: provider for instance
    ///   - queue: a queue that regulates the execution of operations
    ///   - requestDispatcher: dispatcher for JSON RPC requests
    public init(provider prov: Web3Provider, queue: OperationQueue? = nil, requestDispatcher: JSONRPCrequestDispatcher? = nil) {
        provider = prov        
        if requestDispatcher == nil {
            self.requestDispatcher = JSONRPCrequestDispatcher(provider: provider, queue: DispatchQueue.global(qos: .userInteractive), policy: .Batch(32))
        } else {
            self.requestDispatcher = requestDispatcher!
        }
    }
    
    /// Keystore manager can be bound to Web3 instance.
    /// If some manager is bound all further account related functions, such
    /// as account listing, transaction signing, etc.
    /// are done locally using private keys and accounts found in a manager.
    ///
    /// - Parameter manager: keystore manager that is need to be attached
    public func addKeystoreManager(_ manager: KeystoreManager?) {
        self.provider.attachedKeystoreManager = manager
    }
    
    // MARK: - Eth
    
    /// Instance of Eth
    var ethInstance: web3.Eth?
    
    /// Public web3.eth.* namespace.
    public var eth: web3.Eth {
        if (self.ethInstance != nil) {
            return self.ethInstance!
        }
        self.ethInstance = web3.Eth(provider : self.provider, web3: self)
        return self.ethInstance!
    }
    
    
    /// Eth class provides API for interaction with Ethereum blockchain and similar to him networks
    public class Eth {
        /// Provider for Eth instance
        var provider:Web3Provider
        
//        weak var web3: web3?
        
        /// web3 instance for Eth isntance
        var web3: web3
        
        
        /// Raw  initializer using a Web3Provider protocol object and web3 instance.
        ///
        /// - Parameters:
        ///   - prov: Web3Provider for instance
        ///   - web3instance: web3 instance
        public init(provider prov: Web3Provider, web3 web3instance: web3) {
            provider = prov
            web3 = web3instance
        }
    }
    
    // MARK: - Personal
    
    /// Instance of Personal
    var personalInstance: web3.Personal?
    
    /// Public web3.personal.* namespace.
    public var personal: web3.Personal {
        if (self.personalInstance != nil) {
            return self.personalInstance!
        }
        self.personalInstance = web3.Personal(provider : self.provider, web3: self)
        return self.personalInstance!
    }
    
    /// Personal class provides API for interaction with Personal Account
    public class Personal {
        /// Provider for Personal instance
        var provider:Web3Provider
        
        //        weak var web3: web3?
        
        /// web3 instance for Personal isntance
        var web3: web3
        
        /// Raw  initializer using a Web3Provider protocol object and web3 instance.
        ///
        /// - Parameters:
        ///   - prov: Web3Provider for instance
        ///   - web3instance: web3 instance
        public init(provider prov: Web3Provider, web3 web3instance: web3) {
            provider = prov
            web3 = web3instance
        }
    }

    // MARK: - TxPool
    
    /// Instance of TxPool
    var txPoolInstance: web3.TxPool?
    
    /// Public web3.personal.* namespace.
    public var txPool: web3.TxPool {
        if (self.txPoolInstance != nil) {
            return self.txPoolInstance!
        }
        self.txPoolInstance = web3.TxPool(provider : self.provider, web3: self)
        return self.txPoolInstance!
    }
    
    /// TxPool class provides API for interaction with transactions pool
    public class TxPool {
        /// Provider for TxPool instance
        var provider:Web3Provider
        
        //        weak var web3: web3?
        
        /// web3 instance for TxPool isntance
        var web3: web3
        
        /// Raw  initializer using a Web3Provider protocol object and web3 instance.
        ///
        /// - Parameters:
        ///   - prov: Web3Provider for instance
        ///   - web3instance: web3 instance
        public init(provider prov: Web3Provider, web3 web3instance: web3) {
            provider = prov
            web3 = web3instance
        }
    }
    
    // MARK: - Web3Wallet
    
    /// Instance of Web3Wallet
    var walletInstance: web3.Web3Wallet?
    
    /// Public web3.wallet.* namespace.
    public var wallet: web3.Web3Wallet {
        if (self.walletInstance != nil) {
            return self.walletInstance!
        }
        self.walletInstance = web3.Web3Wallet(provider : self.provider, web3: self)
        return self.walletInstance!
    }
    
    /// Web3Wallet class provides API for wallet opetations
    public class Web3Wallet {
        /// Provider for Web3Wallet instance
        var provider:Web3Provider
        
//        weak var web3: web3?
        
        /// web3 instance for Web3Wallet isntance
        var web3: web3
        
        /// Raw  initializer using a Web3Provider protocol object and web3 instance.
        ///
        /// - Parameters:
        ///   - prov: Web3Provider for instance
        ///   - web3instance: web3 instance
        public init(provider prov: Web3Provider, web3 web3instance: web3) {
            provider = prov
            web3 = web3instance
        }
    }
    
    // MARK: - BrowserFunctions
    
    /// Instance of BrowserFunctions
    var browserFunctionsInstance: web3.BrowserFunctions?
    
    /// Public web3.browserFunctions.* namespace.
    public var browserFunctions: web3.BrowserFunctions {
        if (self.browserFunctionsInstance != nil) {
            return self.browserFunctionsInstance!
        }
        self.browserFunctionsInstance = web3.BrowserFunctions(provider : self.provider, web3: self)
        return self.browserFunctionsInstance!
    }
    
    /// BrowserFunctions class provides API for browser opetations
    public class BrowserFunctions {
        /// Provider for BrowserFunctions instance
        var provider:Web3Provider
        
        //        weak var web3: web3?
        
        /// web3 instance for BrowserFunctions isntance
        var web3: web3
        
        /// Raw  initializer using a Web3Provider protocol object and web3 instance.
        ///
        /// - Parameters:
        ///   - prov: Web3Provider for instance
        ///   - web3instance: web3 instance
        public init(provider prov: Web3Provider, web3 web3instance: web3) {
            provider = prov
            web3 = web3instance
        }
    }
    
    // MARK: - Eventloop
    
    /// Instance of Eventloop
    var eventLoopInstance: web3.Eventloop?
    
    /// Public web3.Eventloop.* namespace.
    public var eventLoop: web3.Eventloop {
        if (self.eventLoopInstance != nil) {
            return self.eventLoopInstance!
        }
        self.eventLoopInstance = web3.Eventloop(provider : self.provider, web3: self)
        return self.eventLoopInstance!
    }
    
    /// Eventloop class provides API for events
    public class Eventloop {
        
        public typealias EventLoopCall = (web3) -> Void
        public typealias EventLoopContractCall = (web3contract) -> Void
    
        /// Property which changes are tracked
        public struct MonitoredProperty {
            /// Property name
            public var name: String
            
            // The execution manager of work items
            public var queue: DispatchQueue
            
            /// Called event function
            public var calledFunction: EventLoopCall
        }
        
//        public struct MonitoredContract {
//            public var name: String
//            public var queue: DispatchQueue
//            public var calledFunction: EventLoopContractCall
//        }
        
        /// Provider for Eventloop instance
        var provider:Web3Provider
        
        //        weak var web3: web3?
        
        /// web3 instance for Eventloop isntance
        var web3: web3
        
        /// Timer
        var timer: RepeatingTimer? = nil
        
        /// Properties list for monitoring
        public var monitoredProperties: [MonitoredProperty] = [MonitoredProperty]()
//        public var monitoredContracts: [MonitoredContract] = [MonitoredContract]()
        
        /// Functions list for monitoring
        public var monitoredUserFunctions: [EventLoopRunnableProtocol] = [EventLoopRunnableProtocol]()
        
        /// Raw  initializer using a Web3Provider protocol object and web3 instance.
        ///
        /// - Parameters:
        ///   - prov: Web3Provider for instance
        ///   - web3instance: web3 instance
        public init(provider prov: Web3Provider, web3 web3instance: web3) {
            provider = prov
            web3 = web3instance
        }
    }
    
    public typealias AssemblyHookFunction = ((EthereumTransaction, EthereumContract, TransactionOptions)) -> (EthereumTransaction, EthereumContract, TransactionOptions, Bool)
    
    public typealias SubmissionHookFunction = ((EthereumTransaction, TransactionOptions)) -> (EthereumTransaction, TransactionOptions, Bool)
    
    public typealias SubmissionResultHookFunction = (TransactionSendingResult) -> ()
    
    /// Assebly hooking
    public struct AssemblyHook {
        /// The execution manager of work items
        public var queue: DispatchQueue
        
        /// Function that will hook EthereumTransaction, EthereumContract, TransactionOptions
        public var function: AssemblyHookFunction
    }
    
    /// Submission hooking
    public struct SubmissionHook {
        /// The execution manager of work items
        public var queue: DispatchQueue
        
        /// Function that will hook EthereumTransaction, TransactionOptions
        public var function: SubmissionHookFunction
    }
    
    /// Result submission hooking
    public struct SubmissionResultHook {
        /// The execution manager of work items
        public var queue: DispatchQueue
        
        /// Function that will hook TransactionSendingResult
        public var function: SubmissionResultHookFunction
    }
    
    /// Before assembly hooks
    public var preAssemblyHooks: [AssemblyHook] = [AssemblyHook]()
    
    /// After assembly hooks
    public var postAssemblyHooks: [AssemblyHook] = [AssemblyHook]()
    
    /// Before submission hooks
    public var preSubmissionHooks: [SubmissionHook] = [SubmissionHook]()
    
    /// After submission hooks
    public var postSubmissionHooks: [SubmissionResultHook] = [SubmissionResultHook]()
    
//    #warning("Old ERC721 instance. Don't use it")
//    @available(*, deprecated, message: "Use ERC721 separate class")
//    var erc721Instance: web3.ERC721?
//    
//    /// Public web3.browserFunctions.* namespace.
//    @available(*, deprecated, message: "Use ERC721 separate instance")
//    public var erc721: web3.ERC721 {
//        if (self.erc721Instance != nil) {
//            return self.erc721Instance!
//        }
//        self.erc721Instance = web3.ERC721(provider : self.provider, web3: self)
//        return self.erc721Instance!
//    }
}
