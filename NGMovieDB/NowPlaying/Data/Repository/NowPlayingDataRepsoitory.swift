//
//  NowPlayingDataRepsoitory.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol NowPlayingDataRepsoitoryType {
    @discardableResult
    func requestData(for page: Int,
                     completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable?
}

class NowPlayingDataRepsoitory: NowPlayingDataRepsoitoryType {
    private let remoteDataSource: NowPlayingDataSource
    
    convenience init() {
        self.init(dataSource: NowPlayingRemoteDataSource())
    }
    
    init(dataSource: NowPlayingDataSource) {
        self.remoteDataSource = dataSource
    }
    
    func requestData(for page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        remoteDataSource.getMoviesData(page: page, completion: completion)
    }
}

extension NowPlayingDataRepsoitory: NowPlayingRepository {
    func requestNowPlayingMovies(for page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        requestData(for: page, completion: completion)
    }
}
