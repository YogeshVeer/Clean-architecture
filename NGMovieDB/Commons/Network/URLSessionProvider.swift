//
//  URLSessionProvider.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

public protocol NetworkCancellable {
    func cancel()
}

public protocol SessionProvider {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func loadData(from request: URLRequest,
                  completion: @escaping CompletionHandler) -> NetworkCancellable
}

extension URLSessionTask: NetworkCancellable { }

extension URLSession: SessionProvider {
    public func loadData(from request: URLRequest,
                  completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
        return task
    }
}
