//
//  SearchMovieRemoteDataSource.swift
//  NGMovieDB
//
//  Created by Yogesh on 28.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol SearchMovieRemoteDataSourceType {
    @discardableResult
    func getMoviesForQuery(query: String, page: Int,
                           completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable?
}

class SearchMovieRemoteDataSource: SearchMovieRemoteDataSourceType {
    private let service: APIServiceProvider
    
    convenience init() {
        let appConfiguration = AppConfigurations()
        let config = NetworkConfiguration(baseURL: URL(string: appConfiguration.apiBaseURL)!, headers: [:],
                                          queryParams: ["api_key": appConfiguration.apiKey])
        
        let apiDataNetwork = NetworkService(session: URLSession.shared,
                                            config: config)
        self.init(service: APIService(with: apiDataNetwork))
    }
    
    init(service: APIServiceProvider) {
        self.service =  service
    }
    
    func getMoviesForQuery(query: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        let endPoint: Endpoint<MovieList> =  Endpoint(path: "/3/search/movie/",
                                                      queryParams: ["query": query,
                                                                    "page": "\(page)"])
        let task = service.request(with: endPoint, completion: completion)
        return CancellableTask(networkTask: task)
    }
}

extension SearchMovieRemoteDataSource: SearchMovieDataSource {
    func getMovies(query: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        getMoviesForQuery(query: query,page: page, completion: completion)
    }
}
