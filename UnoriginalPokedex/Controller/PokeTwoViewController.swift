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
                var abilities = [Int:String]()
                DispatchQueue.main.async {
                    let layer = CAGradientLayer()
                    layer.frame = self.view.bounds
                    layer.startPoint = CGPoint(x:1,y:1)
                    layer.startPoint = CGPoint(x:0.2,y:0.2)
                    self.view.layer.insertSublayer(layer, at: 0)
                    
                    self.labels?.forEach {
                        $0.layer.borderWidth = 2.0
                        $0.layer.cornerRadius = 5.0
                        $0.layer.masksToBounds = true
                    }
                    self.abilityLabel?.forEach {
                        $0.layer.cornerRadius = 10.0
                        $0.layer.masksToBounds = true
                    }
                    let type = NSMutableAttributedString()
                    type.append(NSMutableAttributedString(string: "Type :"))
                    
                    if let numTypes = self.pokeInfo?.types {
                        for i in numTypes {
                            let attachment = NSTextAttachment()
                            attachment.image = UIImage(named: "\(i.type.name.capitalized)")
                            attachment.bounds = CGRect(x: 0, y: -3, width: 15, height: 15)
                            let attachedString = NSAttributedString(attachment: attachment)
                            let myString = NSMutableAttributedString(string: i.type.name, attributes: self.outline(fontColor: .white))
                            myString.append(attachedString)
                            type.append(myString)
                        }
                    }
                    
                    self.typeLabel.attributedText = type
                    self.pokeDetail.layer.borderWidth = 2.0
                    self.pokeDetail.layer.cornerRadius = 5.0
                    self.pokeDexNum.attributedText = NSMutableAttributedString(string: "Pokedex # \(pokeNum)", attributes: self.outline(fontColor: .white))
                    self.pokebackground.layer.borderWidth = 2.0
                    self.pokeName.attributedText = NSMutableAttributedString(string: self.pokeInfo!.name.capitalized, attributes: self.outline(fontColor: .white))
                    self.pokeInfo?.abilities.forEach{abilities[$0.slot!] = ($0.ability.name!)}
                    for i in abilities {
                            if i.key == 1 {
                                self.abilityOne.text = i.value.capitalized
                            }
                            if i.key == 2 {
                                self.abilityTwo.text = i.value.capitalized
                            }
                            if i.key == 3 {
                                self.abilityThree.text = "Hidden Ability: \(i.value.capitalized)"
                            }
                    }
                    if let url = URL(string: "https://pokeres.bastionbot.org/images/pokemon/\(pokeNum).png") {
                        ImageHelper.shared.fetchImage(urlString: url.absoluteString) { (error, image) in
                            if let _ = error {
                                if let url = self.pokeInfo?.sprites.front_default {
                                    ImageHelper.shared.fetchImage(urlString: url.absoluteString) { (error, image) in
                                        if let _ = error {
                                            if let image = UIImage(named: "WhatPokeBall"){
                                                self.pokeImage.image = image
                                            }
                                        } else if let image = image {
                                            self.pokeImage.image = image
                                        }
                                    }
                                }
                            } else if let image = image {
                                self.pokeImage.image = image
                            }
                        }
                    }
                }
            }
        }
        PokemonDetailAPIClient.getPokeDetail(keyword: pokeNum) { (error, data) in
            if let error = error {
                print("Error \(error)")
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
    func outline(fontColor: UIColor) -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.strokeWidth : -2,
            NSAttributedString.Key.foregroundColor : fontColor,
            NSAttributedString.Key.strokeColor : UIColor.black
        ]
    }
    @IBAction func Dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
