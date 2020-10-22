//
//  MoviesListViewModel.swift
//  NGMovieDB
//
//  Created by Yogesh on 26.08.20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import Foundation


enum MoviesViewModelState {
    case nowPlaying
    case search
    case loading
}

protocol MoviesListViewModelInput {
    func loadNowPlayingMovies()
    func searchMovies(query: String)
    func updateMovies()
    func didResetState()
    func resetPages()
    var hasMorePages: Bool { get }
    func didSelect(item: MoviePresentationModel)
}

protocol MoviesListViewModelOutput {
    var movies: Observable<[MoviePresentationModel]> { get }
    var isEmpty: Bool { get }
    var viewState: Observable<MoviesViewModelState> { get }
}

typealias MoviesListViewModelType = MoviesListViewModelInput & MoviesListViewModelOutput

class MoviesListViewModel: MoviesListViewModelType {
    
    private let nowPlayingInteractor: NowPlayingDomainInteractorType
    private weak var coordinator: MoviesListCoordinatorType?
    private let searchMoviesInteractor: SearchMovieInteractorType
    private(set) var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var moviesLoadTask: NetworkCancellable? { willSet { moviesLoadTask?.cancel() } }
    
    let movies: Observable<[MoviePresentationModel]> = Observable([MoviePresentationModel]())
    let query: Observable<String> = Observable("")
    let viewState: Observable<MoviesViewModelState> = Observable(.nowPlaying)
    var isEmpty: Bool { return movies.value.isEmpty }
    var nowPlayingMovies: [MoviePresentationModel] = []
    
    var hasMorePages: Bool {
        return currentPage < totalPageCount
    }
    
    var nextPage: Int {
        guard hasMorePages else { return currentPage }
        return currentPage + 1
    }
    
    convenience init(coordinator: MoviesListCoordinatorType) {
        self.init(coordinator: coordinator,
                  nowPlayingInteractor: NowPlayingDomainInteractor(),
                  searchMoviesInteractor: SearchMovieInteractor())
    }
    
    init(coordinator: MoviesListCoordinatorType,
         nowPlayingInteractor: NowPlayingDomainInteractorType,
         searchMoviesInteractor: SearchMovieInteractorType) {
        self.coordinator = coordinator
        self.nowPlayingInteractor = nowPlayingInteractor
        self.searchMoviesInteractor = searchMoviesInteractor
    }
    
    func updateMovies() {
        guard hasMorePages else {
            return
        }
        switch viewState.value {
        case .loading:
            return
        case .nowPlaying:
            loadNowPlayingMovies()
        case .search:
            searchMovies(query: query.value)
        }
    }
    
    func searchMovies(query: String) {
        guard query.isEmpty != true else {
            return
        }
        viewState.value = .loading
        self.query.value = query
        moviesLoadTask = searchMoviesInteractor.getMovies(for: query, page: nextPage) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let movies):
                strongSelf.appendPage(moviesPage: movies)
            case .failure(let error):
                strongSelf.handle(error: error)
            }
            strongSelf.viewState.value = .search
        }
    }
    
    func loadNowPlayingMovies() {
        viewState.value = .loading
        moviesLoadTask = nowPlayingInteractor.getNowPlayingMovies(for: nextPage) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let movies):
                strongSelf.appendPage(moviesPage: movies)
            case .failure(let error):
                strongSelf.handle(error: error)
            }
            strongSelf.viewState.value = .nowPlaying
        }
    }
    
    func didResetState() {
        resetPages()
        moviesLoadTask?.cancel()
        loadNowPlayingMovies()
    }
    
    func resetPages() {
        currentPage = 0
        totalPageCount = 1
        movies.value.removeAll()
        viewState.value = .search
    }
    
    
    private func appendPage(moviesPage: MovieListPresentationModel) {
        self.currentPage = moviesPage.page
        self.totalPageCount = moviesPage.totalPages
        self.movies.value = movies.value + moviesPage.movies
    }
    
    private func handle(error: Error) {
        let error = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading movies", comment: "")
        showError(error)
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
        coordinator?.showAlert(title: NSLocalizedString("Error", comment: ""), message: error)
    }

}

extension MoviesListViewModel {
    func didSelect(item: MoviePresentationModel) {
        coordinator?.showDetail(for: item)
    }
}
