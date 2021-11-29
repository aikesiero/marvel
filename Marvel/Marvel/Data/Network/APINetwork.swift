//
//  CharacterNetwork.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation
import Combine

class APINetwork: NetworkManager, APIProtocol {

    let apiAuth: APIAuth

    init(baseURL: String, publicKey: String, privateKey: String) {
        self.apiAuth = APIAuth(publicKey: publicKey, privateKey: privateKey)
        super.init(baseURL: baseURL)
    }

    func getCharacters() -> AnyPublisher<CharactersResponseDTO, Error> {
        call(endpoint: APIRouter.getCharacters(apiAuth: apiAuth))
    }
}
