//
//  Handler.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

typealias Handler<T> = (Result<T, Error>) -> Void
