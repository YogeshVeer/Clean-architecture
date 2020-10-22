//
//  MoviesListViewController.swift
//  NGMovieDB
//
//  Created by Yogesh on 25.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController, UISearchControllerDelegate {
    
    struct Constants {
        static let previewCellHeight: Double = 160.0
        static let aspectRatio: Double = 1.5
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<String, MoviePresentationModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, MoviePresentationModel>
    
    var viewModel: MoviesListViewModelType!
    private lazy var dataSource = makeDataSource()
    private var loadingView: ReusableLoadingView?
    private lazy var searchController = makeSearchController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialAppearance()
        bindData()
        viewModel.loadNowPlayingMovies()
    }
    
    private func setupInitialAppearance() {
        title = "Now Playing"
        navigationItem.searchController = searchController
        setupCollectionViewLayout()
        setupCollectionView()
    }
    
    func makeSearchController() ->  UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        definesPresentationContext = true
        return searchController
    }
    
    private func setupCollectionView() {
        let loadingReusableNib = UINib(nibName: "ReusableLoadingView", bundle: nil)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ReusableLoadingView")
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    private func setupCollectionViewLayout() {
        let previewLayoutWidth = Constants.previewCellHeight / Constants.aspectRatio
        let layout = CollectionFlowLayout(width: previewLayoutWidth, height: Constants.previewCellHeight)
        collectionView.collectionViewLayout = layout
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, movie) ->
                UICollectionViewCell? in
                let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.update(with: MoviewCollectionCellViewModel(model: movie))
                return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else {
                return nil
            }
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "ReusableLoadingView",
                for: indexPath) as? ReusableLoadingView
            self?.loadingView = view
            return view
        }
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(["Main"])
        snapshot.appendItems(viewModel.movies.value)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func bindData() {
        viewModel.viewState.observe(on: self) { [weak self] items in
            self?.applySnapshot()
        }
    }
}


extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel.viewState.value == .loading {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.value.count - 1 {
            viewModel.updateMovies()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(item: viewModel.movies.value[indexPath.row])
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        viewModel.resetPages()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.resetPages()
        viewModel.searchMovies(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didResetState()
    }
}




