//
//  ImageFetchingDataRepository.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation

protocol ImageFetchingDataRepositoryType {
    func image(with imagePath: String, width: Int,
               completion: @escaping (Result<Data, Error>) -> Void) -> NetworkCancellable?
}

final class ImageFetchingDataRepository {
    
    private let dataTransferService: APIServiceProvider
    private let imageNotFoundData: Data?
    
    convenience init(imageNotFoundData: Data? = nil) {
        let appConfiguration = AppConfigurations()
        let config = NetworkConfiguration(baseURL: URL(string: appConfiguration.imagesBaseURL)!, headers: [:],
                                          queryParams: [:])
        
        let apiDataNetwork = NetworkService(session: URLSession.shared,
                                            config: config)
        self.init(dataTransferService: APIService(with: apiDataNetwork),
                  imageNotFoundData: imageNotFoundData)
    }
    
    init(dataTransferService: APIServiceProvider,
         imageNotFoundData: Data?) {
        self.dataTransferService = dataTransferService
        self.imageNotFoundData = imageNotFoundData
    }
}

extension ImageFetchingDataRepository: ImageFetchingDataRepositoryType {
    
    func image(with imagePath: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> NetworkCancellable? {
        let sizes = [92, 185, 500, 780]
        let availableWidth = sizes.sorted().first { width <= $0 } ?? sizes.last
        let endpoint: Endpoint<Data>  = Endpoint(path: "/t/p/w\(availableWidth!)\(imagePath)",
            responseDecoder: RawDataResponseDecoder())
        let networkTask = dataTransferService.request(with: endpoint) { [weak self] (response: Result<Data, Error>) in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let data):
                completion(.success(data))
                return
            case .failure(let error):
                if case let APIError.networkFailure(networkError) = error, networkError.isNotFoundError,
                    let imageNotFoundData = strongSelf.imageNotFoundData {
                    completion(.success(imageNotFoundData))
                    return
                }
                completion(.failure(error))
                return
            }
        }
        return CancellableTask(networkTask: networkTask)
    }
}

extension ImageFetchingDataRepository: ImageFetchingRepository {
    func getImage(for imagePath: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> NetworkCancellable? {
        image(with: imagePath, width: width, completion: completion)
    }
}
