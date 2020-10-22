//
//  NetworkService.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

public protocol NetworkServiceProvider {
    typealias CompletionHandler = (Result<Data?, ServiceError>) -> Void
    
    func request(endpoint: RequestProvider, completion: @escaping CompletionHandler) -> NetworkCancellable?
}


final public class NetworkService {
    
    private let session: SessionProvider
    private let config: ServiceConfigurable
    
    public init(session: SessionProvider,
                config: ServiceConfigurable) {
        self.session = session
        self.config = config
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        let sessionDataTask = session.loadData(from: request) { data, response, requestError in
            
            if let requestError = requestError {
                var error: ServiceError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
        
        return sessionDataTask
    }
    
    private func resolve(error: Error) -> ServiceError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension NetworkService: NetworkServiceProvider {
    public func request(endpoint: RequestProvider, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(for: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}

