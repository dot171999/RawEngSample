//
//  ScheduleResponse.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import Foundation

struct ScheduleResponse : Decodable {
	let data : ScheduleData

	enum CodingKeys: String, CodingKey {
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		data = try values.decode(ScheduleData.self, forKey: .data)
	}
}
