//
//  NetworkManagerError.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 04/11/24.
//

import Foundation

enum NetworkManagerError: String, Error {
    case httpsRequestFailed
    case jsonDecodingFailed
    case urlRequestTimeout
    case unknown
}
