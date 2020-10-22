//
//  MovieCollectionViewCell.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailView: UIImageView!
    
    private var viewModel: MoviewCollectionCellViewModelType! { didSet { unbind(from: oldValue) } }
    
    func update(with viewModel: MoviewCollectionCellViewModelType) {
        self.viewModel = viewModel
        viewModel.updatePosterImage(width: Int(thumbnailView.frame.size.width * UIScreen.main.scale))
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: MoviewCollectionCellViewModelType) {
        viewModel.posterImage.observe(on: self) { [weak self] (data: Data?) in
            self?.thumbnailView.image = data.flatMap { UIImage(data: $0) }
        }
    }
    
    private func unbind(from item: MoviewCollectionCellViewModelType?) {
        item?.posterImage.remove(observer: self)
    }
}

