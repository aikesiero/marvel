//
//  CoreDataCharactersResponseStorage.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 1/12/21.
//

import Foundation
import CoreData
import Combine

class CoreDataCharactersResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(for requestDTO: CharactersRequestDTO) -> NSFetchRequest<CharactersRequestEntity> {
        let request: NSFetchRequest = CharactersRequestEntity.fetchRequest()

        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d AND %K = %d",
                                        #keyPath(CharactersRequestEntity.query), requestDTO.query ?? "",
                                        #keyPath(CharactersRequestEntity.limit), requestDTO.limit,
                                        #keyPath(CharactersRequestEntity.offset), requestDTO.offset)
        return request
    }

    private func deleteResponse(for requestDto: CharactersRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            Log.error(error)
        }
    }
}

extension CoreDataCharactersResponseStorage: CharactersResponseStorage {

    func getResponse(for requestDto: CharactersRequestDTO)
    -> AnyPublisher<CharactersResponseDTO, CoreDataStorageError> {

        Future<CharactersResponseDTO, CoreDataStorageError> { promise in
            self.coreDataStorage.performBackgroundTask { context in
                do {
                    let fetchRequest = self.fetchRequest(for: requestDto)
                    let requestEntity = try context.fetch(fetchRequest).first

                    guard let result = requestEntity?.response?.toDTO() else {
                        return promise(.failure(CoreDataStorageError.noResult))
                    }
                    return promise(.success(result))
                } catch {
                    return promise(.failure(CoreDataStorageError.readError(error)))
                }
            }
        }.eraseToAnyPublisher()
    }

    func save(response: CharactersResponseDTO, for request: CharactersRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: request, in: context)

                let requestEntity = request.toEntity(in: context)
                requestEntity.response = response.toEntity(in: context)

                try context.save()
            } catch {
                debugPrint("CoreDataCharactersResponseStorage error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
