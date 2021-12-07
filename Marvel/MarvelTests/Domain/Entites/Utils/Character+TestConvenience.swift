//
//  Character+TestConvenience.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

@testable import Marvel

extension Character {
    static func main() -> Character {
        Character(id: CharacterTestData.mainId,
                  name: CharacterTestData.mainName,
                  description: CharacterTestData.mainDescription,
                  imageUrl: CharacterTestData.mainUrl)
    }

    static func alt() -> Character {
        Character(id: CharacterTestData.altId,
                  name: CharacterTestData.altName,
                  description: CharacterTestData.altDescription,
                  imageUrl: CharacterTestData.altUrl)
    }
}
