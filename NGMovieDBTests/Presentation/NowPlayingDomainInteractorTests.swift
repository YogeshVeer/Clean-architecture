//
//  NowPlayingDomainInteractorTests.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import XCTest
@testable import NGMovieDB

class NowPlayingDomainInteractorTests: XCTestCase {
    
    func testMoviesInteractor_whenExecuteUseCase_thenMaptoPresentaionModel() {
        let expectation = self.expectation(description: "Successful results")
        let useCaseMock = NowPlayingMoviesUseCaseSuccessMock()
        let interactor = NowPlayingDomainInteractor(nowPlayingUseCase: useCaseMock, presentationMapper: MoviePresentationMapper())
        var model: MovieListPresentationModel?
        _ = interactor.getNowPlayingMovies(for: 0, completion: { result in
             model = try? result.get()
            expectation.fulfill()
        })
        
        XCTAssertEqual(model?.totalPages, 2)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMoviesInteractor_whenExecuteUseCase_thenError() {
        let expectation = self.expectation(description: "Failure results")
        let useCaseMock = NowPlayingMoviesUseCaseFailureMock()
        let interactor = NowPlayingDomainInteractor(nowPlayingUseCase: useCaseMock, presentationMapper: MoviePresentationMapper())
        var model: MovieListPresentationModel?
        _ = interactor.getNowPlayingMovies(for: 0, completion: { result in
             model = try? result.get()
            expectation.fulfill()
        })
        XCTAssertNil(model)
        waitForExpectations(timeout: 5, handler: nil)
    }

}
