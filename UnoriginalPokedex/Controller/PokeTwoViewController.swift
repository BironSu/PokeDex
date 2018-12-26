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
    var pokeText: PokeDetail?
    @IBOutlet weak var pokeName: UILabel!
    @IBOutlet weak var pokebackground: UIImageView!
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var ability: UILabel!
    @IBOutlet weak var abilityOne: UILabel!
    @IBOutlet weak var abilityTwo: UILabel!
    @IBOutlet weak var abilityThree: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var pokeBackground: UIImageView!
    @IBOutlet weak var pokeDetail: UITextView!
    @IBOutlet weak var pokeDexNum: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet var labels : Array<UILabel>?
    @IBOutlet var abilityLabel : Array<UILabel>?
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
                    let layer = CAGradientLayer()
                    layer.frame = self.view.bounds
                    layer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.green.cgColor]
                    layer.startPoint = CGPoint(x:1,y:1)
                    layer.startPoint = CGPoint(x:0.2,y:0.2)
                    self.view.layer.insertSublayer(layer, at: 0)

                    self.labels?.forEach {
                        $0.layer.borderWidth = 2.0
                        $0.layer.cornerRadius = 5.0
                    }
                    self.abilityLabel?.forEach {
                        $0.layer.cornerRadius = 10.0
                        $0.layer.masksToBounds = true
                    }
                    var type = [String]()
                    if let numTypes = self.pokeInfo?.types {
                        for i in numTypes {
                            type.append(i.type.name)
                        }
                    }
                    self.typeLabel.text = "Type: \(type.joined(separator: "/").capitalized)"
                    self.pokeDetail.layer.borderWidth = 2.0
                    self.pokeDetail.layer.cornerRadius = 5.0
                    self.pokeDexNum.text = "Pokedex # \(pokeNum)"
                    self.pokebackground.layer.borderWidth = 2.0
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
                    if var pokeText = self.pokeText {
                        pokeText.flavor_text_entries = pokeText.flavor_text_entries.filter{$0.language.name.contains("en")}
                        self.pokeDetail.text = pokeText.flavor_text_entries[0].flavor_text
                    }
                }
            }
        }
    }
    @IBAction func Dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
