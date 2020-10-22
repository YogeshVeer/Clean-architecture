//
//  ImageDownloadInteractor.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

protocol ImageDownloadInteractorType {
    func getImage(width: Int, completion: @escaping (Result<Data, Error>) -> Void)
}

class ImageDownloadInteractor: ImageDownloadInteractorType {
    private let imagesRepository: ImageFetchingRepository
    private var posterPath: String? = nil
    private var imageLoadTask: NetworkCancellable? { willSet { imageLoadTask?.cancel() }}
    convenience init(poster: String?) {
        self.init(poster: poster,
                  respository: ImageFetchingDataRepository(imageNotFoundData: Utility.imageNotFoundData))
    }
    
    init(poster: String?,
         respository: ImageFetchingRepository) {
        self.posterPath = poster
        self.imagesRepository = respository
    }
    
    func getImage(width: Int, completion: @escaping (Result<Data, Error>) -> Void){
        guard let posterPath = posterPath else {
            completion(.success(Utility.imageNotFoundData!))
            return
        }
        if let imageFromCache = imageCache.object(forKey: posterPath as AnyObject),
            let image = imageFromCache as? UIImage,
            let data = image.pngData(){
            completion(.success(data))
            return
        }
        
        imageLoadTask = imagesRepository.getImage(for: posterPath, width: width, completion: { [weak self] result in
            guard self?.posterPath == posterPath else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: posterPath as AnyObject)
                completion(.success(data))
            case .failure:
                completion(result)
            }
            self?.imageLoadTask = nil
        })
        
    }
    
}
