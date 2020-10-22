//
//  SearchMovieInteractorTests.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 30.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import XCTest
@testable import NGMovieDB

class SearchMovieInteractorTests: XCTestCase {

    func testSearchMoviesInteractor_whenExecuteUseCase_thenMaptoPresentaionModel() {
        let expectation = self.expectation(description: "Successful results")
        let useCaseMock = SearchMoviesUseCaseSuccessMock()
        let interactor = SearchMovieInteractor(searchMovieUseCase: useCaseMock, presentationMapper: MoviePresentationMapper())
        var model: MovieListPresentationModel?
        _ = interactor.getMovies(for: "Hullk", page: 0, completion: { result in
             model = try? result.get()
            expectation.fulfill()
        })
        
        XCTAssertEqual(model?.totalPages, 2)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchMoviesInteractor_whenExecuteUseCase_thenError() {
        let expectation = self.expectation(description: "Failure results")
        let useCaseMock = SearchMoviesUseCaseFailureMock()
        let interactor = SearchMovieInteractor(searchMovieUseCase: useCaseMock, presentationMapper: MoviePresentationMapper())
        var model: MovieListPresentationModel?
        _ = interactor.getMovies(for: "Hullk", page: 0, completion: { result in
             model = try? result.get()
            expectation.fulfill()
        })
        XCTAssertNil(model)
        waitForExpectations(timeout: 5, handler: nil)
    }

}
