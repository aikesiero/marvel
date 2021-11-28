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
    case error(CharactersListViewModelError)
}

enum CharactersListNavigationDestination {
    case detail
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
}

protocol CharactersListViewModelIO: CharactersListViewModelInput, CharactersListViewModelOutput {}

final class CharactersListViewModel: CharactersListViewModelIO {

    // MARK: - OUTPUT
    @Published var characters: [CharactersListItemViewModel] = []
    @Published var state: CharactersListViewModelState = .loading
    @Published var navigationDestination: CharactersListNavigationDestination?
    let screenTitle = "Characters".localized()
    let searchBarPlaceholder = "SearchPlaceholder".localized()

    // MARK: - Properties
    private var charactersUseCaseFactory: CharactersUseCaseFactory
    private var useCase: UseCase?
    private var currentSearchQuery: String = ""
    
    private var cancellable: AnyCancellable?

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    init(charactersUseCaseFactory: CharactersUseCaseFactory) {
        self.charactersUseCaseFactory = charactersUseCaseFactory
    }

}

// MARK: - INPUT. View event methods
extension CharactersListViewModel {

    func viewDidLoad() {
        Log.debug("VIEW DID LOAD")
        useCase = charactersUseCaseFactory.fetchCharactersUseCase { [weak self] result in
            if case let Result.success(characterPage) = result {
                // TODO: coger datos bien
                Log.debug("Personajes: \(characterPage)")
                self?.state = .finishedLoading
                self?.useCase = nil
            }
        }

        useCase?.execute()
    }

    func didSearch(query: String) {
        Log.debug("VIEW DID SEARCH")
        self.state = .loading
        useCase = charactersUseCaseFactory.fetchCharactersUseCase { [weak self] result in
            if case let Result.success(characterPage) = result {
                // TODO: coger datos bien
                Log.debug("Personajes: \(characterPage)")
                self?.state = .finishedLoading
                self?.useCase = nil
            }
        }
        useCase?.execute()
    }

    func didCancelSearch() {
        _ = self.fetchCharacters()
    }


    func didSelectCharacter(at index: Int) {

    }
    
    func fetchCharacters() -> AnyPublisher<ResponseDTO, NetworkError> {
       Future<ResponseDTO, NetworkError> { [weak self] promise in
            let baseURL = "gateway.marvel.com"
            let network = APINetwork(baseURL: baseURL)
            self?.cancellable = network.getCharacters().sink(receiveCompletion: { completion in
                if case .failure = completion {
                    return promise(.failure(NetworkError.unknownError))
                }
            }, receiveValue: { characters in
                    return promise(.success(characters))
            })
        }.eraseToAnyPublisher()
    }

}
