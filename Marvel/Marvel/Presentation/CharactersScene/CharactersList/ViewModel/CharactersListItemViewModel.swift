//
//  CharactersListItemViewModel.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 26/11/21.
//

import Foundation

struct CharactersListItemViewModel {
    let name: String
}

extension CharactersListItemViewModel {

    init(character: String) {
        self.name = character
    }
}
