//
//  CharactersListViewModel.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 26/11/21.
//

import Foundation
import Combine

enum CharactersListViewModelError: Error, Equatable {
    case errCharactersFetch
}

enum CharactersListViewModelState: Equatable {
    case loading
    case finishedLoading
    case noResults
    case error(CharactersListViewModelError)
}

enum CharactersListNavigationDestination {
    case detail
}

enum CharactersListViewModelLoading {
    case fullScreen
    case nextPage
    case none
}

protocol CharactersListViewModelInput {
    func viewDidLoad()
    func didSearch(query: String)
    func didCancelSearch()
    func didSelectCharacter(at index: Int)
}

protocol CharactersListViewModelOutput: ObservableObject {
    var navigationDestination: CharactersListNavigationDestination? { get }
    var characters: [CharactersListItemViewModel] { get }
    var state: CharactersListViewModelState { get }
    var screenTitle: String { get }
    var searchBarPlaceholder: String { get }
    var loading: CharactersListViewModelLoading { get }
    var emptyDataTitle: String { get }
    var noResultsTitle: String { get }
}

protocol CharactersListViewModelIO: CharactersListViewModelInput, CharactersListViewModelOutput {}

final class CharactersListViewModel: CharactersListViewModelIO {

    // MARK: - OUTPUT
    @Published var characters: [CharactersListItemViewModel] = []
    @Published var state: CharactersListViewModelState = .loading
    @Published var loading: CharactersListViewModelLoading = .none
    @Published var navigationDestination: CharactersListNavigationDestination?
    let screenTitle = "Characters".localized()
    let searchBarPlaceholder = "SearchPlaceholder".localized()
    let emptyDataTitle = "SearchResults".localized()
    let noResultsTitle = "NoResults".localized()

    // MARK: - Properties
    private var charactersUseCaseFactory: CharactersUseCaseFactory
    private var useCase: UseCase?
    private var charactersQuery: CharactersQuery = CharactersQuery()
    private var currentSearchQuery: String = ""
    private var pages: [CharactersPage] = []

    private var cancellable: AnyCancellable?

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    init(charactersUseCaseFactory: CharactersUseCaseFactory) {
        self.charactersUseCaseFactory = charactersUseCaseFactory
    }

    // MARK: - Private

    private func appendPage(_ charactersPage: CharactersPage) {
        currentPage = charactersPage.page
        totalPageCount = charactersPage.totalPages

        pages = pages
            .filter { $0.page != charactersPage.page }
            + [charactersPage]

        characters = pages.characters.map(CharactersListItemViewModel.init)
    }

    private func executeFetchCharactersUseCase() {
        useCase = charactersUseCaseFactory.fetchCharactersUseCase(query: charactersQuery) { [weak self] result in
            if case let .success(characterPage) = result {
                self?.appendPage(characterPage)
                self?.state = .finishedLoading
                self?.loading = .none
            } else if case let .failure(netError) = result {

                if let newError = netError as? CharactersGatewayError {
                    if newError == .noResults {
                        self?.state = .noResults
                    } else {
                        self?.state = .error(.errCharactersFetch)
                    }
                } else {
                    self?.state = .error(.errCharactersFetch)
                }

                self?.loading = .none
            }
            self?.useCase = nil
        }
        useCase?.execute()
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        characters.removeAll()
    }

}

// MARK: - INPUT. View event methods
extension CharactersListViewModel {

    func viewDidLoad() {
        self.executeFetchCharactersUseCase()
    }

    func didLoadNextPage() {
        guard hasMorePages, loading == .none else { return }
        self.loading = .nextPage
        charactersQuery.nextPage()
        self.executeFetchCharactersUseCase()
    }

    func didSearch(query: String) {
        resetPages()
        self.loading = .fullScreen
        self.state = .loading
        charactersQuery = CharactersQuery()
        charactersQuery.query = query
        self.executeFetchCharactersUseCase()
    }

    func didCancelSearch() {
        resetPages()
        charactersQuery.reset()
        self.state = .loading
        self.loading = .fullScreen
        self.executeFetchCharactersUseCase()
    }

    func didSelectCharacter(at index: Int) {

    }
}

// MARK: - Private

private extension Array where Element == CharactersPage {
    var characters: [Character] { flatMap { $0.characters } }
}
