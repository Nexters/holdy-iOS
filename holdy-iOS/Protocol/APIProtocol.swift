import Foundation

protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

protocol Gettable: APIProtocol { }

protocol Postable: Requestable { }

protocol Deletable: Requestable { }

protocol Puttable: Requestable { }

protocol Requestable: APIProtocol {
    var contentType: String? { get }
    var body: Data? { get }
}

enum HttpMethod {
    case get
    case post
    case delete
    case put
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        }
    }
}
