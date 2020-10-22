//
//  APIService.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation


public enum APIError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(ServiceError)
    case resolvedNetworkFailure(Error)
}

public protocol APIServiceProvider {
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: ResponseProvider>(with endpoint: E,
                                                    completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T
}

public protocol APIServiceErrorResolver {
    func resolve(error: ServiceError) -> Error
}

final public class APIService {
    
    private let networkService: NetworkServiceProvider
    private let errorResolver: APIServiceErrorResolver
    
    public init(with networkService: NetworkServiceProvider,
         errorResolver: APIServiceErrorResolver = ServiceRequestErrorResolver()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
    }
}

extension APIService: APIServiceProvider {
    
    public func request<T: Decodable, E: ResponseProvider>(with endpoint: E,
                                                           completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T {
        
        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, Error> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async { return completion(result) }
            case .failure(let error):
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async { return completion(.failure(error)) }
            }
        }
    }
    
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, Error> {
        do {
            guard let data = data else { return .failure(APIError.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(APIError.parsing(error))
        }
    }
    
    private func resolve(networkError error: ServiceError) -> APIError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is ServiceError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}

public class ServiceRequestErrorResolver: APIServiceErrorResolver {
    public init() { }
    public func resolve(error: ServiceError) -> Error {
        return error
    }
}

