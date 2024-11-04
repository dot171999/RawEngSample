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
    
    func getData(from url: URL) async -> Result<Data, NetworkManagerError> {
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(.httpsRequestFailed)
            }
            return .success(data)
        } catch {
            print("nm: ", error)
            if (error as? URLError)?.code == .timedOut {
                return .failure(.urlRequestTimeout)
            }
            return .failure(.unknown)
        }
    }
    
    // Simulate API call
    func getModel<T: Decodable>(from url: URL) async -> Result<T, NetworkManagerError> {
        do {
            try await Task.sleep(for: .seconds(0.2))
            
            let data = try Data(contentsOf: url)
            
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                return .success(model)
            } catch {
                print("nm: ", error)
                return .failure(.jsonDecodingFailed)
            }
        } catch {
            print("nm: ", error, " url: ", url)
            return .failure(.unknown)
        }
    }
}
