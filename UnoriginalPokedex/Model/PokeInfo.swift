//
//  PokeInfo.swift
//  UnoriginalPokedex
//
//  Created by Biron Su on 12/15/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import Foundation

struct PokeInfo: Codable {
    let abilities: [Ability]
    let id: Int
    let name: String
    let sprites: URLSprites
}
struct Ability: Codable {
    let ability: AbilityName
}
struct AbilityName: Codable {
    let name: String?
}
struct URLSprites: Codable {
    let front_default: URL?
}
