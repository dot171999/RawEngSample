//
//  GameCardResponse.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 27/10/24.
//

import Foundation

struct GameCardResponse : Decodable {
    let data : GameCardData?
    
    enum CodingKeys: String, CodingKey {
        case data = "entry"
    }
}

struct GameCardData : Decodable {
    let game_card_config : Game_card_config
    let past_game_card : PastGame
    let upcoming_game : UpcomingGame
    let future_game : FutureGame
    let promotion_cards : [PromotionCard]
    
    struct Game_card_config : Decodable {
        let focus_card : Int
        let future_game_count : Int
        let past_game_count : Int
    }
    
    struct PromotionCard : Decodable, Hashable {
        let position : Int
    }
    
    struct FutureGame : Decodable, Hashable {
        let background_image : GameCardBackgroundImage
        let button : GameCardButton?
   
    }
    
    struct UpcomingGame : Decodable, Hashable {
        let background_image : GameCardBackgroundImage
        let button : GameCardButton?
    }
    
    struct PastGame : Decodable, Hashable {
        let background_image : GameCardBackgroundImage
        let button : GameCardButton
    }
    
    struct GameCardBackgroundImage : Decodable, Hashable {
        let uid : String
        let created_at : String?
        let url : String?
    }
    
    struct GameCardButton : Decodable, Hashable {
        let cta_text : String?
        let icons : Icons
        
        struct Icons : Decodable, Hashable {
            let trailing_icon : Trailing_icon?
            
            struct Trailing_icon : Decodable, Hashable {
                let url : String?
            }
        }
    }
}

