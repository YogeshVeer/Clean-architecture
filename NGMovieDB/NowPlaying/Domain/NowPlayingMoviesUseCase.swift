//
//  NowPlayingMoviesUseCase.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol NowPlayingMoviesUseCaseType {
    func execute(for page: Int,
                 completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable?
}

class NowPlayingMoviesUseCase: NowPlayingMoviesUseCaseType {
    private let nowPlayingRepository: NowPlayingRepository
    
    convenience init() {
        self.init(nowPlayingRepository: NowPlayingDataRepsoitory())
    }
    
    init(nowPlayingRepository: NowPlayingRepository) {
        self.nowPlayingRepository = nowPlayingRepository
    }
    
    func execute(for page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        nowPlayingRepository.requestNowPlayingMovies(for: page, completion: completion)
    }
}
