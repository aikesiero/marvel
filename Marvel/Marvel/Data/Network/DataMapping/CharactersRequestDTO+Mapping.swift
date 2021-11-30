//
//  CharactersRequestDTO+Mapping.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation

public struct CharactersRequestDTO: Encodable {
    let query: String?
    let limit: Int
    let offset: Int
}
