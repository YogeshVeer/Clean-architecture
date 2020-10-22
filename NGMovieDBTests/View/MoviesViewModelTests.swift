//
//  NowPlayingViewModelTests.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import XCTest
@testable import NGMovieDB

class MoviesViewModelTests: XCTestCase {
    
    private let coordinatorMock = MovieListCoordinatorMock()

    override class func tearDown() {
        super.tearDown()
    }
    
    class SearchMoviesInteractorMock: SearchMovieInteractorType {
        var expectation: XCTestExpectation?
        var error: Error?
        var pageModel = MovieList(page: 0, totalPages: 0, movies: [])
        
        func getMovies(for query: String, page: Int, completion: @escaping (Result<MovieListPresentationModel, Error>) -> Void) -> NetworkCancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                let presentationModel = MoviePresentationMapper().map(pageModel)
                completion(.success(presentationModel))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    class NowPlayingMoviesInteractorMock: NowPlayingDomainInteractorType {
        var expectation: XCTestExpectation?
        var error: Error?
        var pageModel = MovieList(page: 0, totalPages: 0, movies: [])
        
        func getNowPlayingMovies(for page: Int, completion: @escaping (Result<MovieListPresentationModel, Error>) -> Void) -> NetworkCancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                let presentationModel = MoviePresentationMapper().map(pageModel)
                completion(.success(presentationModel))
            }
            expectation?.fulfill()
            return nil
        }
    }

    func test_whenNowPlayingMovies_thenViewModelHasPages() {
        let searchInteractorMock = SearchMoviesInteractorMock()
        let moviesInteractorMock = NowPlayingMoviesInteractorMock()
        moviesInteractorMock.expectation =  self.expectation(description: "Movies loaded with page")
        moviesInteractorMock.pageModel = MovieList(page: 1, totalPages: 2, movies: [])
        let viewModel = MoviesListViewModel(coordinator: coordinatorMock, nowPlayingInteractor: moviesInteractorMock, searchMoviesInteractor: searchInteractorMock)
        
        viewModel.loadNowPlayingMovies()
        
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
    }
    
    func test_whenMoviesRequestedMultiplepages_thenViewModelHasMultiplePages() {
        let searchInteractorMock = SearchMoviesInteractorMock()
        let moviesInteractorMock = NowPlayingMoviesInteractorMock()
        moviesInteractorMock.expectation =  self.expectation(description: "first page")
        moviesInteractorMock.pageModel = MovieList(page: 1, totalPages: 2, movies: [])
        let viewModel = MoviesListViewModel(coordinator: coordinatorMock, nowPlayingInteractor: moviesInteractorMock, searchMoviesInteractor: searchInteractorMock)
        
        viewModel.loadNowPlayingMovies()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        moviesInteractorMock.expectation = self.expectation(description: "Second page")
        moviesInteractorMock.pageModel = MovieList(page: 2, totalPages: 2, movies: [])


        viewModel.updateMovies()
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertFalse(viewModel.hasMorePages)
    }
    
    func test_whenNowSearchMovies_thenViewModelHasOnePage() {
        let searchInteractorMock = SearchMoviesInteractorMock()
        let moviesInteractorMock = NowPlayingMoviesInteractorMock()
        searchInteractorMock.expectation =  self.expectation(description: "Movies loaded with page")
        searchInteractorMock.pageModel = MovieList(page: 1, totalPages: 2, movies: [])
        let viewModel = MoviesListViewModel(coordinator: coordinatorMock, nowPlayingInteractor: moviesInteractorMock, searchMoviesInteractor: searchInteractorMock)
        
        viewModel.searchMovies(query: "Hulk")
        
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
    }

    func test_searchAndScroll_thenViewModelHasMultiplePages() {
        let searchInteractorMock = SearchMoviesInteractorMock()
        let moviesInteractorMock = NowPlayingMoviesInteractorMock()
        searchInteractorMock.expectation =  self.expectation(description: "first page")
        searchInteractorMock.pageModel = MovieList(page: 1, totalPages: 2, movies: [])
        let viewModel = MoviesListViewModel(coordinator: coordinatorMock, nowPlayingInteractor: moviesInteractorMock, searchMoviesInteractor: searchInteractorMock)
        
        viewModel.searchMovies(query: "Hulk")

        waitForExpectations(timeout: 5, handler: nil)
        
        searchInteractorMock.expectation = self.expectation(description: "Second page")
        searchInteractorMock.pageModel = MovieList(page: 2, totalPages: 2, movies: [])


        viewModel.updateMovies()
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertFalse(viewModel.hasMorePages)
    }

    func test_whenNowSearchMoviesInteractorReturnsError_thenViewModelHasError() {
        let searchInteractorMock = SearchMoviesInteractorMock()
        let moviesInteractorMock = NowPlayingMoviesInteractorMock()
        searchInteractorMock.expectation =  self.expectation(description: "errors")
        searchInteractorMock.error = SomeError.someError
        let viewModel = MoviesListViewModel(coordinator: coordinatorMock, nowPlayingInteractor: moviesInteractorMock, searchMoviesInteractor: searchInteractorMock)
        
        viewModel.searchMovies(query: "Hulk")
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(coordinatorMock.isErrorAlertShown)
    }

    func test_whenMoviesSelected_thenDetailShown () {
        let viewModel = MoviesListViewModel(coordinator: coordinatorMock)
        viewModel.didSelect(item: MoviePresentationModel(id: "12", title: "", posterPath: "", overview: "", rating: "", backdropPath: ""))
        XCTAssertTrue(coordinatorMock.isDetailStartCalled)
    }
    
    
}
