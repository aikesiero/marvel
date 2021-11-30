//
//  APIProtocol.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation
import Combine

protocol APIProtocol: NetworkManager {
    func getCharacters(with request: CharactersRequestDTO) -> AnyPublisher<CharactersResponseDTO, Error>
}
