//
//  CharactersListItemViewModel.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 26/11/21.
//

import Foundation

struct CharactersListItemViewModel {
    let id: Int
    let name: String
    let description: String?
    let imageURL: String?
}

extension CharactersListItemViewModel {

    init(character: Character) {
        self.id = Int(character.id)
        self.name = character.name ?? ""
        self.description = character.description
        self.imageURL = character.imageUrl
    }
}
