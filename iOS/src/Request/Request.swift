//
//  rRequest.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class Request: NSObject {
    
    public enum Method {
        case get
        case post
        case put
        case patch
        case delete
        case custom(String)
    }

    public enum RequestType {
        case none
        case text(String)
        case json([String: Any])
        case jsonData(Data?)
        case jpeg(Any)
        case png(Any)
        case custom(String, Data?)
    }
    
    public enum Result<T> {
        case success(T)
        case error(Error)
    }
    
    public enum Error: Swift.Error {
        case urlNotSpecified
        case emptyResponse
        case parseFailed
        case wrongResponseData
        case wrongResponseDataType
        case server(Int, Data?, URLResponse?)
    }
    
    public var url: URL? = nil
    public var method: Method = .get
    public var params: [String: Any]? = nil
    public var headers: [String: Any]? = nil
    public var requestType: RequestType = .none
    public var requestQueue: Queue.Group = .new
    public var resultQueue: Queue.Group = .main
    public var stringEncoding: String.Encoding = .utf8

    public var session: URLSession?

    public static var requestTimeout: TimeInterval = 60
    public static var responseTimeout: TimeInterval = 300
    public static var isPretty = true

    public typealias ResultClosure = (_ result: Result<Data>) -> Void
    public typealias ResultClosureType<T> = (_ result: Result<T>) -> Void
    
    private static var requests: [Int: Request] = [:]
    private var task: URLSessionDataTask?

    // Builder

    public func url(_ url: String?) -> Self {
        self.url = url != nil ? URL(string: url!) : nil
        return self
    }
    
    public func url(_ url: URL?) -> Self {
        self.url = url
        return self
    }
    
    public func method(_ method: Method) -> Self {
        self.method = method
        return self
    }
    
    public func params(_ params: [String: Any]?) -> Self {
        self.params = params
        return self
    }
    
    public func headers(_ headers: [String: Any]?) -> Self {
        self.headers = headers
        return self
    }

    public func requestType(_ requestType: RequestType) -> Self {
        self.requestType = requestType
        return self
    }
    
    public func requestQueue(_ requestQueue: Queue.Group) -> Self {
        self.requestQueue = requestQueue
        return self
    }
    
    public func resultQueue(_ resultQueue: Queue.Group) -> Self {
        self.resultQueue = resultQueue
        return self
    }
    
    public func stringEncoding(_ encoding: String.Encoding) -> Self {
        self.stringEncoding = encoding
        return self
    }

    
    // Run
    
    public func run<T: Decodable>(_ result: @escaping ResultClosureType<T>) {
        run { [weak self] _result in
            guard let self = self else { return }
            switch _result {
            case .success(let data):
                if T.self == String.self {
                    if let string = String(data: data, encoding: self.stringEncoding) {
                        result(.success(string as! T))
                    } else {
                        result(.error(.wrongResponseData))
                    }
                } else if T.self == Int.self {
                    if let string = String(data: data, encoding: self.stringEncoding),
                        let int = Int(string) {
                        result(.success(int as! T))
                    } else {
                        result(.error(.wrongResponseData))
                    }
                } else if T.self == Double.self {
                    if let string = String(data: data, encoding: self.stringEncoding),
                        let double = Double(string) {
                        result(.success(double as! T))
                    } else {
                        result(.error(.wrongResponseData))
                    }
                } else {
                    Queue.run(self.requestQueue) {
                        if let object = try? JSONDecoder().decode(T.self, from: data) {
                            Queue.run(self.resultQueue) {
                                result(.success(object))
                            }
                        } else {
                            Queue.run(self.resultQueue) {
                                result(.error(.wrongResponseData))
                            }
                        }
                    }
                }
            case .error(let error):
                result(.error(error))
            }
        }
    }
    
    public func run<T>(_ result: @escaping ResultClosureType<T>) {
        run { [weak self] _result in
            guard let self = self else { return }
            switch _result {
            case .success(let data):
                if T.self == Data.self {
                    result(.success(data as! T))
                } else if T.self == UIImage.self {
                    Queue.run(self.requestQueue) {
                        if let image = UIImage(data: data) {
                            Queue.run(self.resultQueue) {
                                result(.success(image as! T))
                            }
                        } else {
                            Queue.run(self.resultQueue) {
                                result(.error(.wrongResponseData))
                            }
                        }
                    }
                } else {
                    result(.error(.wrongResponseDataType))
                }
            case .error(let error):
                result(.error(error))
            }
        }
    }

    public func run(_ result: ResultClosure? = nil) {
        guard let url = url else {
            result?(.error(.urlNotSpecified))
            return
        }
        Request.requests[self.hash] = self
        Queue.run(requestQueue) { [weak self] in
            guard let self = self else { return }
            let request = NSMutableURLRequest(url: url)
            
            if self.session == nil {
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = Request.requestTimeout
                configuration.timeoutIntervalForResource = Request.responseTimeout
                self.session = URLSession(configuration: configuration)
            }
            
            switch self.method {
            case .get:
                request.httpMethod = "GET"
            case .post:
                request.httpMethod = "POST"
            case .put:
                request.httpMethod = "PUT"
            case .patch:
                request.httpMethod = "PATCH"
            case .delete:
                request.httpMethod = "DELETE"
            case .custom(let name):
                request.httpMethod = name.uppercased()
            }
            
            if self.params != nil {
                switch self.requestType {
                case .none: break
                case .text(let text):
                    request.httpBody = text.data(using: .utf32)
                    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
                case .json:
                    request.httpBody = try? JSONSerialization.data(withJSONObject: self.params!, options: Request.isPretty ? .prettyPrinted : [])
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                case .jsonData(let data):
                    request.httpBody = data
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                case .jpeg(let image):
                    if let image = image as? Data {
                        request.httpBody = image
                    } else if let image = image as? UIImage {
                        request.httpBody = image.jpegData(compressionQuality: 0.8)
                    }
                    request.addValue("application/jpeg", forHTTPHeaderField: "Content-Type")
                case .png(let image):
                    if let image = image as? Data {
                        request.httpBody = image
                    } else if let image = image as? UIImage {
                        request.httpBody = image.pngData()
                    }
                    request.addValue("application/png", forHTTPHeaderField: "Content-Type")
                case .custom(let type, let data):
                    request.httpBody = data
                    request.addValue(type, forHTTPHeaderField: "Content-Type")
                }
            }
            
            self.headers?.forEach() { arg in
                let (key, value) = arg
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
            
            self.task?.cancel()
            
            self.task = self.session?.dataTask(with: request as URLRequest) { data, response, error -> Void in
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

                if 200..<300 ~= statusCode {
                    Queue.run(self.resultQueue) {
                        Request.requests.removeValue(forKey: self.hash)
                        result?(.success(data ?? Data()))
                    }
                } else {
                    Queue.run(self.resultQueue) {
                        Request.requests.removeValue(forKey: self.hash)
                        result?(.error(.server(statusCode, data, response)))
                    }
                }
            }
            self.task?.resume()
        }
    }

    public func pause() {
        task?.suspend()
    }
    
    public func resume() {
        task?.resume()
    }
    
    public func cancel() {
        task?.cancel()
        task = nil
        Request.requests.removeValue(forKey: hash)
    }
}
