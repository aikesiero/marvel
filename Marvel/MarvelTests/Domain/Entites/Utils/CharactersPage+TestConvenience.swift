//
//  CharactersPage+TestConvenience.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

@testable import Marvel

extension CharactersPage {
    static func main() -> CharactersPage {
        CharactersPage(page: 1, totalPages: 10, characters: [Character.main()])
    }

    static func alt() -> CharactersPage {
        CharactersPage(page: 1, totalPages: 10, characters: [Character.main()])
    }
}
