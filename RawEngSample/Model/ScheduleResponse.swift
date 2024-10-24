import Foundation

struct ScheduleResponse : Codable {
	let data : GameData?

	enum CodingKeys: String, CodingKey {

		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		data = try values.decodeIfPresent(GameData.self, forKey: .data)
	}
}
