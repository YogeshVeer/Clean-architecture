//
//  MoviesDetailViewModelTests.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 30.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import XCTest
@testable import NGMovieDB

class MoviesDetailViewModelTests: XCTestCase {
    
    class ImageDownloadingInteractorMock: ImageDownloadInteractorType {
        var expectation: XCTestExpectation?
        var error: Error?
        var image = Data()
        var validateInput: ((String, Int) -> Void)?
        let imagePath = "posterPath"
        func getImage(width: Int, completion: @escaping (Result<Data, Error>) -> Void) {
            validateInput?(imagePath, width)
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(image))
            }
            expectation?.fulfill()
        }
    }

    
    func test_DetailModelProvided_ViewModelIsUpdate() {
        let coordinator = MovieDetailCoordinatorMock()
        let imageInteractor = ImageDownloadingInteractorMock()
        imageInteractor.expectation = self.expectation(description: "Image with download")
        let expectedImage = "image data".data(using: .utf8)!
        imageInteractor.image = expectedImage
        let model = MoviePresentationModel(id: "1", title: "Movie1", posterPath: "/poster", overview: "overview", rating: "10", backdropPath: "/posterPath")
        let viewModel = MovieDetailViewModel(coordinator: coordinator, movieModel: model, interactor: imageInteractor)
        
        imageInteractor.validateInput = { (imagePath: String, width: Int) in
            XCTAssertEqual(imagePath, "posterPath")
            XCTAssertEqual(width, 200)
        }
        
        viewModel.updatePosterImage(width: 200)
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.posterImage.value, expectedImage)
        XCTAssertEqual(viewModel.title,model.title)
        XCTAssertEqual(viewModel.overview,model.overview)
        XCTAssertEqual(viewModel.rating,model.rating)
    }

}
