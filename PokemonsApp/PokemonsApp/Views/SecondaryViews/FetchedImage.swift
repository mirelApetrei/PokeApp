//
//  FetchedImage.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 28.10.23.
//

import SwiftUI

struct FetchedImage: View {
    // MARK: - PROPERTIES
    let url: URL?

    var body: some View {
        if let url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 10)
        } else {
            Image("bulbasaur")
        }
    }
}

#Preview {
    FetchedImage(url: SamplePokemon.samplePokemon.sprite)
}
