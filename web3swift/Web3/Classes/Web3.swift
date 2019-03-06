//  web3swift
//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation

/// `Web3Error` is the error type returned by web3swift. It encompasses a few different types of errors, each with
/// their own associated reasons.
///
/// - transactionSerializationError: Returned when there is a fail in creating WriteTransaction or ReadTransaction object.
/// - connectionError:               Returned when there is no response in Request results.
/// - dataError:                     Returned when creating `Data` object throws error.
/// - walletError:                   Returned when there is some error with Wallet, for example with keystoreManager.
/// - inputError:                    Returned when there is some error in input.
/// - nodeError:                     Returned when node returns some error.
/// - processingError:               Returned when node returns wrong result.
/// - keystoreError:                 Returned when there is some problem with keystore.
/// - generalError:                  Returned when it is the general type error.
/// - unknownError:                  Returned when error can't be classified.
public enum Web3Error: Error {
    case transactionSerializationError
    case connectionError
    case dataError
    case walletError
    case inputError(desc:String)
    case nodeError(desc:String)
    case processingError(desc:String)
    case keystoreError(err:AbstractKeystoreError)
    case generalError(err:Error)
    case unknownError
    
    /// Web3Error description
    var description : String {
        switch self {
            
        case .transactionSerializationError:
            return "Transaction Serialization Error"
        case .connectionError:
            return "Connection Error"
        case .dataError:
            return "Data Error"
        case .walletError:
            return "Wallet Error"
        case .inputError(let desc):
            return desc
        case .nodeError(let desc):
            return desc
        case .processingError(let desc):
            return desc
        case .keystoreError(let err):
            return err.localizedDescription
        case .generalError(let err):
            return err.localizedDescription
        case .unknownError:
            return "Unknown Error"
        }
    }
}

/// Global namespace containing API for an arbitary Web3 instance. Is used only to construct provider bound
/// fully functional object by either supplying provider URL or using pre-coded Infura nodes.
public struct Web3 {
    
    /// Initialized provider-bound Web3 instance using a provider's URL.
    /// Under the hood it performs a synchronous call to get the Network ID
    /// for EIP155 purposes.
    ///
    /// - Parameter providerURL: contains server information that can be used for requests.
    /// - Returns: web3 instance bound to provider.
    public static func new(_ providerURL: URL) -> web3? {
        guard let provider = Web3HttpProvider(providerURL) else {return nil}
        return web3(provider: provider)
    }
    
    /// Initialized Web3 instance bound to Infura's mainnet provider.
    ///
    /// - Parameter accessToken: contains the security credentials
    /// - Returns: web3 instance bound to provider.
    public static func InfuraMainnetWeb3(accessToken: String? = nil) -> web3 {
        let infura = InfuraProvider(Networks.Mainnet, accessToken: accessToken)!
        return web3(provider: infura)
    }
    
    /// Initialized Web3 instance bound to Infura's rinkeby provider.
    ///
    /// - Parameter accessToken: contains the security credentials
    /// - Returns: web3 instance bound to provider.
    public static func InfuraRinkebyWeb3(accessToken: String? = nil) -> web3 {
        let infura = InfuraProvider(Networks.Rinkeby, accessToken: accessToken)!
        return web3(provider: infura)
    }
    
    /// Initialized Web3 instance bound to Infura's ropsten provider.
    ///
    /// - Parameter accessToken: contains the security credentials
    /// - Returns: web3 instance bound to provider.
    public static func InfuraRopstenWeb3(accessToken: String? = nil) -> web3 {
        let infura = InfuraProvider(Networks.Ropsten, accessToken: accessToken)!
        return web3(provider: infura)
    }
    
}

/// Unwrapper for wrapped result
struct ResultUnwrapper {
    /// Returns response from dictionary
    ///
    /// - Parameter response: dictionaried response
    /// - Returns: Response of Any type
    /// - Throws: An `Web3Error` if the unwrapping process encounters an error.
    static func getResponse(_ response: [String: Any]?) throws -> Any {
        guard response != nil, let res = response else {
            throw Web3Error.connectionError
        }
        if let error = res["error"] {
            if let errString = error as? String {
                throw Web3Error.nodeError(desc: errString)
            } else if let errDict = error as? [String:Any] {
                if errDict["message"] != nil, let descr = errDict["message"]! as? String  {
                    throw Web3Error.nodeError(desc: descr)
                }
            }
            throw Web3Error.unknownError
        }
        guard let result = res["result"] else {
            throw Web3Error.dataError
        }
        return result
    }
}
