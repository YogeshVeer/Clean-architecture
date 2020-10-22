//
//  MoviewDetailViewController.swift
//  NGMovieDB
//
//  Created by Yogesh on 27.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit

class MoviewDetailViewController: UIViewController {
    
    var viewModel: MovieDetailViewModelType!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        viewModel.didMove(toParent: parent)
    }
    
    private func bindData() {
        viewModel.updatePosterImage(width: Int(posterImageView.frame.size.width * UIScreen.main.scale))
        titleLabel.text = viewModel.title
        title = viewModel.title
        overviewLabel.text = viewModel.overview
        ratingLabel.text = viewModel.rating
        viewModel.posterImage.observe(on: self) { [weak self] (data: Data?) in
            self?.posterImageView.image = data.flatMap { UIImage(data: $0) }
        }
    }
}
