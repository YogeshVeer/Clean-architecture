//
//  SearchMovieUseCaseTests.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 30.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import XCTest
@testable import NGMovieDB

class SearchMovieUseCaseTests: XCTestCase {

    func testSearchUseCase_whenRequestPage_thenSuccessfulResults() {
        let expectation = self.expectation(description: "Successful results")
        let mockRespository = SearchMoviesDataRepositorySuccessMock()
        let usecase = SearchMoviesUseCase(searchMovieRepository: mockRespository)
        var model: MovieList?
        _ = usecase.execute(for: "Hulk", page: 0, completion: { result in
             model = try? result.get()
            expectation.fulfill()
        })
        XCTAssertNotNil(model)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNowplayingUseCase_whenRequestPage_thenSuccessfailureResults() {
        let expectation = self.expectation(description: "Failure results")
        let mockRespository = SearchMoviesDataRepositoryFailureMock()
        let usecase = SearchMoviesUseCase(searchMovieRepository: mockRespository)
        var model: MovieList?
        _ = usecase.execute(for: "Hulk", page: 0, completion: { result in
             model = try? result.get()
            expectation.fulfill()
        })
        XCTAssertNil(model)
        waitForExpectations(timeout: 5, handler: nil)
    }

}
