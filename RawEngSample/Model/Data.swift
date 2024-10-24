import Foundation

struct GameData : Codable {
	let schedules : [Schedule]?

	enum CodingKeys: String, CodingKey {

		case schedules = "schedules"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		schedules = try values.decodeIfPresent([Schedule].self, forKey: .schedules)
	}

}
