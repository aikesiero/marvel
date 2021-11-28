//
//  CharacterNetwork.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation
import Combine

class APINetwork: NetworkManager, APIProtocol {

    func getCharacters() -> AnyPublisher<ResponseDTO, Error> {
        call(endpoint: APIRouter.getCharacters)
    }
}


struct ResponseDTO: Decodable {
    var code: String?
}
