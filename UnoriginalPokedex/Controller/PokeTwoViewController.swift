//
//  PokeTwoViewController.swift
//  UnoriginalPokedex
//
//  Created by Biron Su on 12/15/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import UIKit

class PokeTwoViewController: UIViewController {
    var pokeData: NameURL?
    var pokeInfo: PokeInfo?
    var pokeText: TextEntries?
    @IBOutlet weak var pokeName: UILabel!
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var abilityOne: UILabel!
    @IBOutlet weak var abilityTwo: UILabel!
    @IBOutlet weak var abilityThree: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var pokeBackground: UIImageView!
    @IBOutlet weak var pokeDetail: UITextView!
    @IBOutlet weak var pokeDexNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let pokeData = pokeData {
            getPokeInfo(data: pokeData)
        }
    }

    func getPokeInfo(data: NameURL) {
        let pokeNum = data.url.absoluteString.components(separatedBy: "/")[6]
        PokemonInfoAPIClient.getPokeInfo(keyword: pokeNum) { (error, data) in
            if let error = error {
                print("Error PokeTwoVC \(error)")
            } else if let data = data {
                self.pokeInfo = data
                var abilities = [String]()
                DispatchQueue.main.async {
                    self.pokeDexNum.text = "Pokedex # \(pokeNum)"
                    self.pokeName.text = self.pokeInfo?.name.capitalized
                    self.pokeInfo?.abilities.forEach{abilities.append($0.ability.name!)}
                    for i in 0..<abilities.count{
                        if i == 0 {
                            self.abilityOne.text = abilities[i].capitalized
                        }
                        if i == 1 {
                            self.abilityTwo.text = abilities[i].capitalized
                        }
                        if i == 3 {
                            self.abilityThree.text = abilities[i].capitalized
                        }
                    }
                    if let url = self.pokeInfo?.sprites.front_default {
                        ImageHelper.fetchImage(urlString: url.absoluteString) { (error, image) in
                            if let error = error {
                                print("Image Error: \(error)")
                            } else if let image = image {
                                self.pokeImage.image = image
                            }
                        }
                    } else {
                        self.pokeImage.image = UIImage(named: "Pokeball-PNG-High-Quality-Image")
                    }
                }
            }
        }
        PokemonDetailAPIClient.getPokeDetail(keyword: pokeNum) { (error, data) in
            if let error = error {
                print("Error Detail \(error)")
            } else if let data = data {
                self.pokeText = data
                DispatchQueue.main.async {
                    if let pokeText = self.pokeText {
                        self.pokeDetail.text = pokeText.flavor_text
                    }
                }
            }
        }
    }
    
    @IBAction func Dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
