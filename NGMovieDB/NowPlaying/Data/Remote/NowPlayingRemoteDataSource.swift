//
//  NowPlayingRemoteDataSource.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol NowPlayingRemoteDataSourceType {
    @discardableResult
    func getNowPlayingMovies(page: Int,
                             completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable?
}

class NowPlayingRemoteDataSource: NowPlayingRemoteDataSourceType {
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
    
    func getNowPlayingMovies(page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        let endPoint: Endpoint<MovieList> =  Endpoint(path: "/3/movie/now_playing",
                                                      queryParams: ["page": "\(page)"])
        let task = service.request(with: endPoint, completion: completion)
        return CancellableTask(networkTask: task)
    }
}

extension NowPlayingRemoteDataSource: NowPlayingDataSource {
    func getMoviesData(page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        getNowPlayingMovies(page: page, completion: completion)
    }
}
