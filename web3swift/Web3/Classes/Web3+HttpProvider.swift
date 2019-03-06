//  web3swift
//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt
import PromiseKit

/// Providers abstraction for custom providers (websockets, other custom private key managers). At the moment should not be used.
public protocol Web3Provider {
    /// Sends JSON RPC request in chosen queue asynchronously
    ///
    /// - Parameters:
    ///   - request: a stateless, light-weight remote procedure call (RPC) protocol
    ///   - queue: an object-like structure that manages the tasks
    /// - Returns: Promise of JSON RPC response structure
    func sendAsync(_ request: JSONRPCrequest, queue: DispatchQueue) -> Promise<JSONRPCresponse>
    
    /// Sends JSON RPC request in chosen queue asynchronously
    ///
    /// - Parameters:
    ///   - requests: JSON RPC batch request structure
    ///   - queue: an object-like structure that manages the tasks
    /// - Returns: Promise of JSON RPC batch response structure
    func sendAsync(_ requests: JSONRPCrequestBatch, queue: DispatchQueue) -> Promise<JSONRPCresponseBatch>
    
    /// Network used in provider
    var network: Networks? {get set}
    
    /// Attached keysotre to provider
    var attachedKeystoreManager: KeystoreManager? {get set}
    
    /// Provider URL
    var url: URL {get}
    
    /// URL session
    var session: URLSession {get}
}


/// The default http provider.
public class Web3HttpProvider: Web3Provider {
    /// URL session
    public var url: URL
    
    /// Network used in provider
    public var network: Networks?
    
    /// Attached keysotre manager to provider
    public var attachedKeystoreManager: KeystoreManager? = nil
    
    
    /// /// URL session
    public var session: URLSession = {() -> URLSession in
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        return urlSession
    }()
    
    /// Create an instance of the default http provider from an array of `HTTPHeader`s.
    /// Duplicate case-insensitive names are collapsed into the last name and value encountered.
    ///
    /// - Parameters:
    ///   - httpProviderURL: http provider URL
    ///   - net: Network used
    ///   - manager: attached keystore manager
    public init?(_ httpProviderURL: URL, network net: Networks? = nil, keystoreManager manager: KeystoreManager? = nil) {
        do {
            guard httpProviderURL.scheme == "http" || httpProviderURL.scheme == "https" else {return nil}
            url = httpProviderURL
            if net == nil {
                let request = JSONRPCRequestFabric.prepareRequest(.getNetwork, parameters: [])
                let response = try Web3HttpProvider.post(request, providerURL: httpProviderURL, queue: DispatchQueue.global(qos: .userInteractive), session: session).wait()
                if response.error != nil {
                    if response.message != nil {
                        print(response.message!)
                    }
                    return nil
                }
                guard let result: String = response.getValue(), let intNetworkNumber = Int(result) else {return nil}
                network = Networks.fromInt(intNetworkNumber)
                if network == nil {return nil}
            } else {
                network = net
            }
        } catch {
            return nil
        }
        attachedKeystoreManager = manager
    }
}

