//
//  NetworkManagerProtocol.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 30/10/24.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func getData(from url: URL) async -> Result<Data, NetworkManagerError>
    func getModel<T: Decodable>(from url: URL) async -> Result<T, NetworkManagerError>
}
