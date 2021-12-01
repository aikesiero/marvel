//
//  Character.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

import Foundation

struct Character: Equatable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    let name: String?
    let description: String?
    let imageUrl: String?
}

struct CharactersPage: Equatable {
    let page: Int
    let totalPages: Int
    let characters: [Character]
}
