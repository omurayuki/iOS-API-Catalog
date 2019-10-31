import Foundation

extension NSError {
    static func create(code: Int = 0, message: String) -> NSError {
        NSError(domain: "com.github.tattn.Suica", code: code, userInfo: [
            NSLocalizedDescriptionKey: message
        ])
    }
}

extension FixedWidthInteger {
    init(bytes: UInt8...) {
        self.init(bytes: bytes)
    }

    init<T: DataProtocol>(bytes: T) {
        let count = bytes.count - 1
        self = bytes.enumerated().reduce(into: 0) { (result, item) in
            result += Self(item.element) << (8 * (count - item.offset))
        }
    }
}

extension Optional {
    func orThrow(_ error: Error) throws -> Wrapped {
        if let value = self {
            return value
        } else {
            throw error
        }
    }
}

extension DispatchQueue {
    static func mainAsyncIfNeeded(execute work: @escaping @convention(block) () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}

import CoreNFC

extension NFCTagReaderSession {
    func _invalidate(errorMessage: String?) {
        if let message = errorMessage {
            invalidate(errorMessage: message)
        } else {
            invalidate()
        }
    }
}

extension NFCReaderError {
    init(error: Error) {
        if let error = error as? NFCReaderError {
            self = error
        } else {
            self.init(_nsError: error as NSError)
        }
    }
}
