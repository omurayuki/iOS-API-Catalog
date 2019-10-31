import Foundation

public struct ReaderConfiguration {
    public var message = Message()

    public init() {}
}

public extension ReaderConfiguration {
    struct Message {
        public var alert: String?
        public var foundMultipleTags: String?

        public init() {}
    }
}
