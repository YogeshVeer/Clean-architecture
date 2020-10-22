//
//  NowPlayingRepository.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol NowPlayingRepository {
    @discardableResult
    func requestNowPlayingMovies(for page: Int,
                                 completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable?
}
