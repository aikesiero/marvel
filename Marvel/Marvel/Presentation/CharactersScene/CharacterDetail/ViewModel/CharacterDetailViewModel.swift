//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 1/12/21.
//

import Foundation
import Combine

enum CharacterDetailViewModelError: Error, Equatable {
    case errCharactersFetch
}

enum CharacterDetailViewModelState: Equatable {
    case loading
    case finishedLoading
    case noResults
    case error(CharacterDetailViewModelError)
}

protocol CharacterDetailViewModelInput {
    func viewDidLoad()
}

protocol CharacterDetailViewModelOutput: ObservableObject {
    var character: CharactersListItemViewModel? { get }
    var state: CharactersListViewModelState { get }
    var screenTitle: String { get }

}

protocol CharacterDetailViewModelIO: CharacterDetailViewModelInput, CharacterDetailViewModelOutput {}

final class CharacterDetailViewModel: CharacterDetailViewModelIO {

    // MARK: - OUTPUT
    @Published var character: CharactersListItemViewModel?
    @Published var state: CharactersListViewModelState = .loading
    let screenTitle = "Detail".localized()

    // MARK: - Properties
    private var charactersUseCaseFactory: CharactersUseCaseFactory
    private var useCase: UseCase?

    private var cancellable: AnyCancellable?

    private let idCharacter: Int

    init(charactersUseCaseFactory: CharactersUseCaseFactory,
         idCharacter: Int) {
        self.charactersUseCaseFactory = charactersUseCaseFactory
        self.idCharacter = idCharacter
    }

    // MARK: - Private

    private func executeFetchCharacterUseCase() {
        useCase = charactersUseCaseFactory.fetchCharacterUseCase(id: idCharacter) { [weak self] result in
            if case let .success(character) = result {
                self?.character = CharactersListItemViewModel(character: character)
                self?.state = .finishedLoading
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
            }
            self?.useCase = nil
        }
        useCase?.execute()
    }

}

// MARK: - INPUT. View event methods
extension CharacterDetailViewModel {

    func viewDidLoad() {
        self.executeFetchCharacterUseCase()
    }
}
