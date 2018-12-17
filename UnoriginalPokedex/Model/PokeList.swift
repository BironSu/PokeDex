//
//  PokeList.swift
//  UnoriginalPokedex
//
//  Created by Biron Su on 12/15/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import Foundation

// info for TableView
struct PokemonList: Codable {
    let results: [NameURL]
}
struct NameURL: Codable {
    let name: String
    let url: URL
}
