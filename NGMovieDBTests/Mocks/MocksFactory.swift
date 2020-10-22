//
//  MocksFactory.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation
@testable import NGMovieDB

enum SomeError: Error {
    case someError
}

class NowPlayingMoviesUseCaseSuccessMock: NowPlayingMoviesUseCaseType {
    func execute(for page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        completion(.success(MovieListsMock.moviesPages[page]))
        return nil
    }
}

class NowPlayingMoviesUseCaseFailureMock: NowPlayingMoviesUseCaseType {
    func execute(for page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        completion(.failure(SomeError.someError))
        return nil
    }
}

class NowPlayingDataRepositorySuccessMock: NowPlayingRepository {
    func requestNowPlayingMovies(for page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        completion(.success(MovieListsMock.moviesPages[page]))
        return nil
    }
}

class NowPlayingDataRepositoryFailureMock: NowPlayingRepository {
    func requestNowPlayingMovies(for page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        completion(.failure(SomeError.someError))
        return nil
    }
}

class NowPlayingRemoteDataSourceSuccessMock: NowPlayingDataSource {
    func getMoviesData(page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        completion(.success(MovieListsMock.moviesPages[page]))
        return nil
    }
}

class NowPlayingRemoteDataSourceFailureMock: NowPlayingDataSource {
    func getMoviesData(page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        completion(.failure(SomeError.someError))
        return nil
    }
}

class NowPlayingDomainInteractorSuccessMock: NowPlayingDomainInteractorType {
    func getNowPlayingMovies(for page: Int, completion: @escaping (Result<MovieListPresentationModel, Error>) -> Void) -> NetworkCancellable? {
        let presentationModel = MoviePresentationMapper().map(MovieListsMock.moviesPages[page])
        completion(.success(presentationModel))
        return nil
    }
}

class NowPlayingDomainInteractorFailureMock: NowPlayingDomainInteractorType {
    func getNowPlayingMovies(for page: Int, completion: @escaping (Result<MovieListPresentationModel, Error>) -> Void) -> NetworkCancellable? {
        completion(.failure(SomeError.someError))
        return nil
    }
}

class SearchMoviesInteractorSuccessMock: SearchMovieInteractorType {
    func getMovies(for query: String, page: Int, completion: @escaping (Result<MovieListPresentationModel, Error>) -> Void) -> NetworkCancellable? {
        let presentationModel = MoviePresentationMapper().map(MovieListsMock.moviesPages[page])
        completion(.success(presentationModel))
        return nil
    }
}

class SearchMoviesInteractorFailureMock: SearchMovieInteractorType {
    func getMovies(for query: String, page: Int, completion: @escaping (Result<MovieListPresentationModel, Error>) -> Void) -> NetworkCancellable? {
        completion(.failure(SomeError.someError))
        return nil
    }
}

class SearchMoviesDataRepositorySuccessMock: SearchMoviesRepository {
    func requestMovies(for query: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        completion(.success(MovieListsMock.moviesPages[page]))
        return nil
    }
}

class SearchMoviesDataRepositoryFailureMock: SearchMoviesRepository {
    func requestMovies(for query: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        completion(.failure(SomeError.someError))
        return nil
        
    }
}


class SearchMoviesUseCaseSuccessMock: SearchMoviesUseCaseType {
    func execute(for query: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        completion(.success(MovieListsMock.moviesPages[page]))
        return nil
    }
}

class SearchMoviesUseCaseFailureMock: SearchMoviesUseCaseType {
    func execute(for query: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) -> NetworkCancellable? {
        completion(.failure(SomeError.someError))
        return nil
        
    }
}



