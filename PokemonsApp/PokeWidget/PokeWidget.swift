//
//  PokeWidget.swift
//  PokeWidget
//
//  Created by Apetrei Mirel on 28.10.23.
//

import WidgetKit
import SwiftUI
import CoreData

/// This struct provides the timeline for the PokeWidget.
struct Provider: AppIntentTimelineProvider {

    var randomPokemon: Pokemon {
        /// Context for PersistenceController
        let context = PersistenceController.shared.container.viewContext

        /// Fetch request for Pokemon
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        var results: [Pokemon] = []

        do {
            results = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching data \(error)")
        }

        if let randomPokemon = results.randomElement() {
            return randomPokemon
        }
        return SamplePokemon.samplePokemon
    }


    /// This function provides a placeholder for the widget when it's loading or has no data.
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), pokemon: SamplePokemon.samplePokemon)
    }

    /// This function provides a snapshot of the widget, used for quick look previews.
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, pokemon: randomPokemon)
    }

    /// This function provides the timeline for the widget, generating entries for the next five hours.
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        /// Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, pokemon: randomPokemon)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let pokemon: Pokemon
}

struct PokeWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetSize
    var entry: Provider.Entry

    var body: some View {
        switch widgetSize {
            case .systemSmall:
            WidgetPokemon(widgetSize: .small)
                .environmentObject(entry.pokemon)
                .ignoresSafeArea()

        case .systemMedium:
            WidgetPokemon(widgetSize: .medium)
            .environmentObject(entry.pokemon)

        case .systemLarge:
            WidgetPokemon(widgetSize: .large)
            .environmentObject(entry.pokemon)
            .ignoresSafeArea()

        default:
            WidgetPokemon(widgetSize: .large)
            .environmentObject(entry.pokemon)
        }
    }
}

struct PokeWidget: Widget {
    let kind: String = "PokeWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PokeWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .containerBackground(.fill.tertiary, for: .widget)

        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemMedium) {
    PokeWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, pokemon: SamplePokemon.samplePokemon)
    SimpleEntry(date: .now, configuration: .starEyes, pokemon: SamplePokemon.samplePokemon)
}
