import Foundation
import CoreNFC

protocol Tag {
    associatedtype ConcreteTag
    
    var rawValue: ConcreteTag { get }
    static var pollingOption: NFCTagReaderSession.PollingOption { get }
    static func read(_ tag: ConcreteTag, completion: @escaping (Result<Self, TagErrors>) -> Void)
    static func __read(_ tag: NFCTag, completion: @escaping (Result<Self, TagErrors>) -> Void)
}

extension Tag where ConcreteTag == NFCFeliCaTag {
    static var pollingOption: NFCTagReaderSession.PollingOption {
        .iso18092
    }
    
    var idm: String {
        rawValue.currentIDm.map { String(format: "%.2hhx", $0) }.joined()
    }
    
    var systemCode: String {
        rawValue.currentSystemCode.map { String(format: "%.2hhx", $0) }.joined()
    }
    
    static func __read(_ tag: NFCTag, completion: @escaping (Result<Self, TagErrors>) -> Void) {
        guard case .feliCa(let feliCaTag) = tag else {
            completion(.failure(.typeMismatch))
            return
        }
        read(feliCaTag, completion: completion)
    }
}

public enum TagErrors: Error {
    case typeMismatch
    case requestFailure(Error)
    case serviceNotFound
    case readFailure(Error)
    case decodeFailure(Error)
    case dataInconsistency
}
