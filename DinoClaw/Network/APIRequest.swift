//Roar

import Foundation

public typealias HTTPHeaders = [String: String]

public typealias APIRequestCompletion = (Data?, Error?) -> Void

public class APIRequest {
    
    private static var defaultCallbackQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "APIRequest default callback queue"
        queue.qualityOfService = .utility
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private static let defaultSession = URLSession(configuration: .default, delegate: nil, delegateQueue: defaultCallbackQueue)
    private static let mainThreadCallbackSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
    public enum APIRequestResponseError: Error {
        case nilData
    }
    
    public enum HTTPMethod: String {
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case connect = "CONNECT"
        case options = "OPTIONS"
        case trace = "TRACE"
        case patch = "PATCH"
    }
    
    @discardableResult
    public static func request(url: URL,
                               method: HTTPMethod = .get,
                               parameters: [String: String]? = nil,
                               headers: HTTPHeaders = [:],
                               timeoutInterval: TimeInterval = 60.0,
                               callBackOnMainThread: Bool = false,
                               completion: @escaping APIRequestCompletion) -> URLSessionDataTask {
        
        let urlRequest = urlRequestFor(url: url, method: method, parameters: parameters, headers: headers, timeoutInterval: timeoutInterval)
        
        let session = callBackOnMainThread ? mainThreadCallbackSession : defaultSession

        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            
            if let error = error {
                completion(nil, error)
            } else if let error = httpResponse?.validateStatusCode(statusCode: 200..<300) {
                completion(nil, error)
            }
            
            guard let data = data else {
                completion(nil, APIRequestResponseError.nilData)
                return
            }
            
            completion(data, nil)
        }
        task.resume()
        return task
    }
    
    public static func urlRequestFor(url: URL,
                                     method: HTTPMethod = .get,
                                     parameters: [String: String]? = nil,
                                     headers: HTTPHeaders = [:],
                                     timeoutInterval: TimeInterval = 60.0) -> URLRequest {
        let url = url.addParams(parameters ?? [:])
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        return urlRequest
    }
}

public extension HTTPURLResponse {
        
    enum HTTPURLResponseError: Error {
        case invalidStatusCode
    }
    
    func validateStatusCode<S: Sequence>(statusCode acceptedStatusCodes: S) -> Error? where S.Iterator.Element == Int {
        return acceptedStatusCodes.contains(statusCode) ? nil : HTTPURLResponseError.invalidStatusCode
    }
}
