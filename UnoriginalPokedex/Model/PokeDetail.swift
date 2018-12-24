//
//  PokeDetail.swift
//  UnoriginalPokedex
//
//  Created by Biron Su on 12/20/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import Foundation

struct PokeDetail: Codable {
    var flavor_text_entries: [TextEntries]
}
struct TextEntries: Codable {
    let flavor_text: String
    let language: Language
}
struct Language: Codable {
    let name: String
}
