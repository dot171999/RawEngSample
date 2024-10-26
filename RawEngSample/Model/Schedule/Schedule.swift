//
//  Schedule.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import Foundation

struct Schedule : Decodable, Hashable {
	let uid : String
	let year : Int?
	let league_id : String?
	let season_id : String?
	let gid : String?
	let gcode : String?
	let seri : String?
	let is_game_necessary : String?
	let gametime : String
	let cl : String?
	let arena_name : String?
	let arena_city : String?
	let arena_state : String?
	let st : Int?
	let stt : String?
	let ppdst : String?
	let buy_ticket : String?
	let buy_ticket_url : String?
	let logo_url : String?
	let hide : Bool?
	let game_state : String?
	let game_subtype : String?
	let h : H
	let v : V
    
    let readableGameDate: String
    let readableGameTime: String
    let readableGameMonYear: String
    
	enum CodingKeys: String, CodingKey {

		case uid = "uid"
		case year = "year"
		case league_id = "league_id"
		case season_id = "season_id"
		case gid = "gid"
		case gcode = "gcode"
		case seri = "seri"
		case is_game_necessary = "is_game_necessary"
		case gametime = "gametime"
		case cl = "cl"
		case arena_name = "arena_name"
		case arena_city = "arena_city"
		case arena_state = "arena_state"
		case st = "st"
		case stt = "stt"
		case ppdst = "ppdst"
		case buy_ticket = "buy_ticket"
		case buy_ticket_url = "buy_ticket_url"
		case logo_url = "logo_url"
		case hide = "hide"
		case game_state = "game_state"
		case game_subtype = "game_subtype"
		case h = "h"
		case v = "v"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		uid = try values.decode(String.self, forKey: .uid)
		year = try values.decodeIfPresent(Int.self, forKey: .year)
		league_id = try values.decodeIfPresent(String.self, forKey: .league_id)
		season_id = try values.decodeIfPresent(String.self, forKey: .season_id)
		gid = try values.decodeIfPresent(String.self, forKey: .gid)
		gcode = try values.decodeIfPresent(String.self, forKey: .gcode)
		seri = try values.decodeIfPresent(String.self, forKey: .seri)
		is_game_necessary = try values.decodeIfPresent(String.self, forKey: .is_game_necessary)
		gametime = try values.decode(String.self, forKey: .gametime)
		cl = try values.decodeIfPresent(String.self, forKey: .cl)
		arena_name = try values.decodeIfPresent(String.self, forKey: .arena_name)
		arena_city = try values.decodeIfPresent(String.self, forKey: .arena_city)
		arena_state = try values.decodeIfPresent(String.self, forKey: .arena_state)
		st = try values.decodeIfPresent(Int.self, forKey: .st)
		stt = try values.decodeIfPresent(String.self, forKey: .stt)
		ppdst = try values.decodeIfPresent(String.self, forKey: .ppdst)
		buy_ticket = try values.decodeIfPresent(String.self, forKey: .buy_ticket)
		buy_ticket_url = try values.decodeIfPresent(String.self, forKey: .buy_ticket_url)
		logo_url = try values.decodeIfPresent(String.self, forKey: .logo_url)
		hide = try values.decodeIfPresent(Bool.self, forKey: .hide)
		game_state = try values.decodeIfPresent(String.self, forKey: .game_state)
		game_subtype = try values.decodeIfPresent(String.self, forKey: .game_subtype)
		h = try values.decode(H.self, forKey: .h)
		v = try values.decode(V.self, forKey: .v)
        
        readableGameDate = gametime.toReadableDateFormatFromISO8601("EEE MMM dd") ?? ""
        readableGameTime = gametime.toReadableDateFormatFromISO8601("h:mm a") ?? ""
        readableGameMonYear = gametime.toReadableDateFormatFromISO8601("MMM yyyy") ?? ""
	}
}

