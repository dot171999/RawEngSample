//
//  ScheduleData.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import Foundation

struct ScheduleData : Decodable {
	let schedules : [Schedule]?

	enum CodingKeys: String, CodingKey {

		case schedules = "schedules"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		schedules = try values.decodeIfPresent([Schedule].self, forKey: .schedules)
	}

}
