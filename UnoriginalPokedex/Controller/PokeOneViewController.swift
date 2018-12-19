//
//  ViewController.swift
//  UnoriginalPokedex
//
//  Created by Biron Su on 12/15/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import UIKit

class PokeOneViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var pokeList = [NameURL]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var pokeInfo: PokeInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        getList(keyword: "")
        
    }
    func getList(keyword: String) {
        PokemonListAPIClient.searchPokemon(keyword: keyword) { (error, pokeData) in
            if let error = error {
                print("ErrorVDL \(error)")
            } else if let pokeData = pokeData {
                self.pokeList = pokeData
            }
        }
    }
    @objc func pokeSegue() {
        self.performSegue(withIdentifier: "pokeSegue", sender: TableViewCell.self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow, let destination = segue.destination as? PokeTwoViewController else {fatalError("index path is nil")}
        let data = pokeList[indexPath.row]
        destination.pokeData = data
    }
}
extension PokeOneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell", for: indexPath) as? TableViewCell else {return TableViewCell()}
        let cellToSet = pokeList[indexPath.row]
        let pokeNum = cellToSet.url.absoluteString.components(separatedBy: "/")[6]
        cell.labelOne.text = cellToSet.name.capitalized
        cell.labelTwo.text = "Pokedex #\(pokeNum)"
        cell.pokeImageView.image = UIImage(named: "Pokeball")
        cell.pokeCellImage.image = UIImage(named: "PokemonCell")
        cell.layer.cornerRadius = 10.0
        cell.clipsToBounds = true
        cell.layer.borderWidth = 6.0
    
        return cell
    }
}
extension PokeOneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        let pokeNum = pokeList[indexPath.row].url.absoluteString.components(separatedBy: "/")[6]
        PokemonInfoAPIClient.getPokeInfo(keyword: pokeNum) { (error, pokeinfo) in
            if let error = error {
                print("Image change error \(error)")
            } else if let pokeinfo = pokeinfo {
                self.pokeInfo = pokeinfo
                DispatchQueue.main.async {
                    if let url = self.pokeInfo?.sprites.front_default {
                        ImageHelper.fetchImage(urlString: url.absoluteString) { (error, image) in
                            if let error = error {
                                print("Error at imageHelper \(error)")
                            } else if let image = image {
                                cell.pokeImageView.image = image
                                Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.pokeSegue), userInfo: nil, repeats: false)
                            }
                        }
                    }
                }
            }
        }
    }
}
extension PokeOneViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            getList(keyword: keyword)
        }
    }
}
