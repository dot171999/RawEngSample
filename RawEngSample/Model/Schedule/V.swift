//
//  V.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import Foundation

struct V : Decodable, Hashable {
    let tid : String
    let re : String?
    let ta : String
    let tn : String?
    let tc : String?
    let s : String?
    let ist_group : String?
    
    enum CodingKeys: String, CodingKey {
        
        case tid = "tid"
        case re = "re"
        case ta = "ta"
        case tn = "tn"
        case tc = "tc"
        case s = "s"
        case ist_group = "ist_group"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tid = try values.decode(String.self, forKey: .tid)
        re = try values.decodeIfPresent(String.self, forKey: .re)
        ta = try values.decode(String.self, forKey: .ta)
        tn = try values.decodeIfPresent(String.self, forKey: .tn)
        tc = try values.decodeIfPresent(String.self, forKey: .tc)
        s = try values.decodeIfPresent(String.self, forKey: .s)
        ist_group = try values.decodeIfPresent(String.self, forKey: .ist_group)
    }
}
