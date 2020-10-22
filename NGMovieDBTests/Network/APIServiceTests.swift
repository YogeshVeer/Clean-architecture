//
//  APIServiceTests.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import XCTest
import NGMovieDB

private struct MockModel: Decodable {
    let name: String
}

class APIServiceTests: XCTestCase {
    
    private enum APIErrorMock: Error {
        case someError
    }
    
    private let mockUrl = "http://mockDB.com"

    func test_whenReceivedValidJsonInResponse_shouldDecodeResponseToDecodableObject() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should decode mock object")
        
        let responseData = #"{"name": "Hello"}"#.data(using: .utf8)
        let networkService = NetworkService(session: SessionProviderMock(response: nil,
                                                                               data: responseData,
                                                                               error: nil),
                                                   config: config)
        
        let sut = APIService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: mockUrl, method: .get)) { result in
            do {
                let object = try result.get()
                XCTAssertEqual(object.name, "Hello")
                expectation.fulfill()
            } catch {
                XCTFail("Failed decoding MockObject")
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenInvalidResponse_shouldNotDecodeObject() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should not decode mock object")
        
        let responseData = #"{"age": 20}"#.data(using: .utf8)
        let networkService = NetworkService(session: SessionProviderMock(response: nil,
                                                                               data: responseData,
                                                                               error: nil),
                                                   config: config)
        
        let sut = APIService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: mockUrl, method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenBadRequestReceived_shouldRethrowNetworkError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should throw network error")
        
        let responseData = #"{"invalidStructure": "Nothing"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: nil)
        let networkService = NetworkService(session: SessionProviderMock(response: response,
                                                                               data: responseData,
                                                                               error: APIErrorMock.someError),
                                                   config: config)
        
        let sut = APIService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: mockUrl, method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                
                if case APIError.networkFailure(ServiceError.error(statusCode: 500, data: _)) = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenNoDataReceived_shouldThrowNoDataError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should throw no data error")
        
        let response = HTTPURLResponse(url: URL(string: mockUrl)!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let networkService = NetworkService(session: SessionProviderMock(response: response,
                                                                               data: nil,
                                                                               error: nil),
                                                   config: config)
        
        let sut = APIService(with: networkService)
        //when
        _ = sut.request(with: Endpoint<MockModel>(path: mockUrl, method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case APIError.noResponse = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
}
