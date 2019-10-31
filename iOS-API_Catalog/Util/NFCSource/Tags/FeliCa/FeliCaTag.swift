import Foundation
import CoreNFC

protocol FeliCaTag: Tag {
    static var services: [FeliCaService.Type] { get }
}
