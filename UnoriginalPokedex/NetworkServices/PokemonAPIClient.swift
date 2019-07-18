//
//  PokemonAPIClient.swift
//  UnoriginalPokedex
//
//  Created by Biron Su on 12/17/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import Foundation

final class PokemonListAPIClient {
    static func searchPokemon(keyword: String, completionHandler: @escaping(Error?, [NameURL]? ) -> Void ) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=200"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
    
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                do {
                    if keyword.isEmpty {
                        let pokeData = try JSONDecoder().decode(PokemonList.self, from: data)
                        completionHandler(nil, pokeData.results)
                    } else {
                        let pokeData = try JSONDecoder().decode(PokemonList.self, from: data)
                        completionHandler(nil, pokeData.results.filter{$0.name.contains(keyword.lowercased())})
                    }
                } catch {
                    completionHandler(error, nil)
                }
            }
        }.resume()
    }
}
final class PokemonInfoAPIClient {
    static func getPokeInfo(keyword: String, completionHandler: @escaping(Error?, PokeInfo?) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(keyword)/"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                do {
                    let pokeInfo = try JSONDecoder().decode(PokeInfo.self, from: data)
                    
                    completionHandler(nil, pokeInfo)
                } catch {
                    completionHandler(error, nil)
                }
            }
        }.resume()
    }
}
final class PokemonDetailAPIClient {
    static func getPokeDetail (keyword: String, completionHandler: @escaping(Error?, PokeDetail?) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon-species/\(keyword)/"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                do {
                    let pokeDetail = try JSONDecoder().decode(PokeDetail.self, from: data)
                    completionHandler(nil, pokeDetail)
                } catch {
                    completionHandler(error, nil)
                }
            }
        }.resume()
    }
}
