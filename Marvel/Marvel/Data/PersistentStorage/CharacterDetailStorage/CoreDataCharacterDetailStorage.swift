//
//  CoreDataCharacterDetailStorage.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 2/12/21.
//

import Foundation
import CoreData
import Combine

final class CoreDataCharacterDetailStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(for id: Int) -> NSFetchRequest<CharacterResponseEntity> {
        let request: NSFetchRequest = CharacterResponseEntity.fetchRequest()

        request.predicate = NSPredicate(format: "%K = %d",
                                        #keyPath(CharacterResponseEntity.idCharacter), id)
        return request
    }

    private func deleteResponse(for id: Int, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: id)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            Log.error(error)
        }
    }
}

extension CoreDataCharacterDetailStorage: CharacterDetailStorage {

    func getCharacter(for id: Int) -> AnyPublisher<CharacterDTO, CoreDataStorageError> {

        Future<CharacterDTO, CoreDataStorageError> { promise in
            self.coreDataStorage.performBackgroundTask { context in
                do {
                    let fetchRequest = self.fetchRequest(for: id)
                    let requestEntity = try context.fetch(fetchRequest).first

                    guard let result = requestEntity?.toDTO() else {
                        return promise(.failure(CoreDataStorageError.noResult))
                    }
                    return promise(.success(result))
                } catch {
                    return promise(.failure(CoreDataStorageError.readError(error)))
                }
            }
        }.eraseToAnyPublisher()
    }

    func save(character: CharacterDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: character.id, in: context)
                _ = character.toEntity(in: context)
                try context.save()
            } catch {
                debugPrint("CoreDataCharacterDetailStorage error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
