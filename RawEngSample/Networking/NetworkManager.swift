//
//  NetworkManager.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 30/10/24.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {
    private let sessionTimeoutInSeconds: TimeInterval = 8
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = sessionTimeoutInSeconds
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: configuration)
    }
    
    func getData(from url: URL) async throws -> Data {
        let (data, _) = try await session.data(from: url)
        return data
    }
    
    // Simulate API call
    func getModel<T: Decodable>(from url: URL) async throws -> T {
        do {
            try await Task.sleep(for: .seconds(0.2))
        } catch {
            print("error: ", error, "url: ", url)
        }
        
        let data = try Data(contentsOf: url)
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}
