//
//  PokeWidgetBundle.swift
//  PokeWidget
//
//  Created by Apetrei Mirel on 28.10.23.
//

import WidgetKit
import SwiftUI

@main
struct PokeWidgetBundle: WidgetBundle {
    var body: some Widget {
        PokeWidget()
        PokeWidgetLiveActivity()
    }
}
