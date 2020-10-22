//
//  URLSessionMock.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import NGMovieDB
import Foundation

struct SessionProviderMock: SessionProvider {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func loadData(from request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkCancellable {
        completion(data, response, error)
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        return urlSession.dataTask(with: request)
        
    }
    
}
