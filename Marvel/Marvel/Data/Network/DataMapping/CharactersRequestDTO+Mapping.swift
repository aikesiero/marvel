//
//  CharactersRequestDTO+Mapping.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation

struct CharactersRequestDTO: Encodable {
    let query: String?
    let page: Int?
}
