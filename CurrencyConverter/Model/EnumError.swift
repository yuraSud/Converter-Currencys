
import Foundation

enum NetworkRequestError: Error {
    case noData
    case statusCode
    case notValidURL
    case parseError
}
