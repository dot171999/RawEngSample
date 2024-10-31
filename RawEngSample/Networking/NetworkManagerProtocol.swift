//
//  NetworkManagerProtocol.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 30/10/24.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func getModel<T: Decodable>(from url: URL) async throws -> T
    func getData(from url: URL) async throws -> Data
}
