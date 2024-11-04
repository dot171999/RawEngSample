//
//  DefaultURLProvider.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 04/11/24.
//

import Foundation

protocol URLProviderProtocol {
    var baseURL: URL { get }
    func endpoint(for endpoint: APIEndpoint) -> URL?
}

struct DefaultURLProvider: URLProviderProtocol {
    
    var baseURL: URL = URL(string: "www.test.com")!
    
    func endpoint(for endpoint: APIEndpoint) -> URL? {
        let _ = baseURL.appendingPathComponent(endpoint.path)
        // dummy baseUrl just return bundle url
        return Bundle.main.url(forResource: endpoint.path, withExtension: "json")
    }
}
