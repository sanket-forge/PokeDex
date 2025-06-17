//
//  PokemonModel.swift
//  PokeDex
//
//  Created by Sanket Khatua on 17/06/25.
//

import Foundation

import Foundation

struct PokemonListResponse: Codable {
    
    let results: [PokemonEntry]
}

struct PokemonEntry: Codable, Identifiable {
    
    let name: String
    let url: String
    var spriteURL: String?
    
    var id: String { name }
}

struct PokemonDetail: Codable {
    
    let sprites: Sprites
    struct Sprites: Codable {
        let front_default: String?
    }
}

class PokemonViewModel: ObservableObject {
    
    @Published var pokemonList: [PokemonEntry] = []
    
    init() {
        
        fetchPokemon()
    }
    
    func fetchPokemon() {
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=200") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                print("Fetch error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                var list = try JSONDecoder().decode(PokemonListResponse.self, from: data).results
                let group = DispatchGroup()
                
                for i in 0..<list.count {
                    
                    group.enter()
                    self.fetchSprite(for: list[i].url) { spriteURL in
                        list[i].spriteURL = spriteURL
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    
                    self.pokemonList = list
                }
            } catch {
                
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    
    private func fetchSprite(for urlString: String, completion: @escaping (String?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            guard let data = data else {
                
                completion(nil)
                return
            }
            
            do {
                
                let detail = try JSONDecoder().decode(PokemonDetail.self, from: data)
                completion(detail.sprites.front_default)
            } catch {
                
                completion(nil)
            }
        }.resume()
    }
}

