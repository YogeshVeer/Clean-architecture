//
//  NetworkServiceTests.swift
//  NGMovieDBTests
//
//  Created by Yogesh on 29.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import XCTest
import NGMovieDB

class NetworkServiceTests: XCTestCase {
    
    private let mockUrl = "http://mockDB.com"

    func test_whenMockDataPassed_shouldReturnProperResponse() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Data received")
        
        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = NetworkService(session: SessionProviderMock(response: nil,
                                                                    data: expectedResponseData,
                                                                    error: nil),
                                        config: config)
        //when
        _ = sut.request(endpoint: EndpointMock(path: mockUrl, method: .get)) { result in
            guard let responseData = try? result.get() else {
                XCTFail("Data received")
                return
            }
            XCTAssertEqual(responseData, expectedResponseData)
            expectation.fulfill()
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenErrorWithNSURLErrorCancelledReturned_shouldReturnCancelledError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let sut = NetworkService(session: SessionProviderMock(response: nil,
                                                                    data: nil,
                                                                    error: cancelledError as Error),
                                        config: config)
        //when
        _ = sut.request(endpoint: EndpointMock(path: mockUrl, method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case ServiceError.cancelled = error else {
                    XCTFail("NetworkError.cancelled not found")
                    return
                }
                
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenMalformedUrlPassed_shouldReturnUrlGenerationError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return correct data")
        
        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = NetworkService(session: SessionProviderMock(response: nil,
                                                                    data: expectedResponseData,
                                                                    error: nil),
                                        config: config)
        //when
        _ = sut.request(endpoint: EndpointMock(path: "-^&%#^", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should throw url generation error")
            } catch let error {
                guard case ServiceError.urlGeneration = error else {
                    XCTFail("Should throw url generation error")
                    return
                }
                
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldReturnNotConnectedError() {
        //given
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let sut = NetworkService(session: SessionProviderMock(response: nil,
                                                                    data: nil,
                                                                    error: error as Error),
                                        config: config)
        
        //when
        _ = sut.request(endpoint: EndpointMock(path: mockUrl, method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case ServiceError.notConnected = error else {
                    XCTFail("NetworkError.notConnected not found")
                    return
                }
                
                expectation.fulfill()
            }
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
}
