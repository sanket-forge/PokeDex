//
//  ContentView.swift
//  PokeDex
//
//  Created by Sanket Khatua on 17/06/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = PokemonViewModel()
    
    var body: some View {
        
        NavigationView {
            List(viewModel.pokemonList) { pokemon in
                HStack {
                    if let spriteURL = pokemon.spriteURL, let url = URL(string: spriteURL) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Color.clear.frame(width: 50, height: 50)
                    }
                    Text(pokemon.name.capitalized)
                }
            }
            .navigationTitle("PokeDex")
        }
    }
}

#Preview {
    ContentView()
}
