//
//  RequestProvider.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

public enum HttpMethod: String {
    case get = "GET"
}

public enum RequestProviderError: Error {
    case requestProviderFailed
}

public protocol RequestProvider {
    var path: String { get }
    var method: HttpMethod { get }
    var queryParams: [String: Any] { get }
    var headers: [String: String] { get }
    var body: [String: Any] { get }
    
    func urlRequest(for networkConfig: ServiceConfigurable) throws -> URLRequest
}

extension RequestProvider {
    
    func url(for config: ServiceConfigurable) throws -> URL {

        let baseURL = config.baseURL.absoluteString
        let endpoint = baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw RequestProviderError.requestProviderFailed
        }
        
        var urlQueryItems = [URLQueryItem]()
        
        queryParams.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        
        config.queryParams.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else {
            throw RequestProviderError.requestProviderFailed
        }
        return url
    }
    
    public func urlRequest(for config: ServiceConfigurable) throws -> URLRequest {
        let url = try self.url(for: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headers.forEach { allHeaders.updateValue($1, forKey: $0) }
        
        if !body.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
}
