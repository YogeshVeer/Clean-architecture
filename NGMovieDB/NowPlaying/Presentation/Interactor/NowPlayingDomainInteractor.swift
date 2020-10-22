//
//  NowPlayingDomainInteractor.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation


protocol NowPlayingDomainInteractorType {
    func getNowPlayingMovies(for page: Int,
                             completion: @escaping (Result<MovieListPresentationModel, Error>) -> Void) -> NetworkCancellable?
}


class NowPlayingDomainInteractor: NowPlayingDomainInteractorType {
    
    private let nowPlayingUseCase: NowPlayingMoviesUseCaseType
    private let presentationMapper: MoviePresentationMapper
    
    convenience init() {
        self.init(nowPlayingUseCase: NowPlayingMoviesUseCase(),
                  presentationMapper: MoviePresentationMapper())
    }
    
    init(nowPlayingUseCase: NowPlayingMoviesUseCaseType,
         presentationMapper: MoviePresentationMapper) {
        self.nowPlayingUseCase = nowPlayingUseCase
        self.presentationMapper = presentationMapper
    }
    
    func getNowPlayingMovies(for page: Int, completion: @escaping (Result<MovieListPresentationModel, Error>) -> Void) -> NetworkCancellable? {
        nowPlayingUseCase.execute(for: page) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let movieList):
                let mappedModel = strongSelf.mapToPresentationModel(model: movieList)
                completion(.success(mappedModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func mapToPresentationModel(model: MovieList) -> MovieListPresentationModel {
        presentationMapper.map(model)
    }
}
