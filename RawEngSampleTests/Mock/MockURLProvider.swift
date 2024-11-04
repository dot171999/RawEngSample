//
//  MockURLProvider.swift
//  RawEngSampleTests
//
//  Created by Aryan Sharma on 03/11/24.
//

import Foundation
@testable import RawEngSample

struct MockURLProvider: URLProviderProtocol {
    
    var baseURL: URL = URL(string: "www.test.com")!
    
    func endpoint(for endpoint: APIEndpoint) -> URL? {
        let _ = baseURL.appendingPathComponent(endpoint.path)
        // No baseUrl just return bundle url
        return Bundle.main.url(forResource: "Mock_" + endpoint.path, withExtension: "json")
    }
}
 

