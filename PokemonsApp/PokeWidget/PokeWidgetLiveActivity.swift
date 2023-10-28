//
//  PokeWidgetLiveActivity.swift
//  PokeWidget
//
//  Created by Apetrei Mirel on 28.10.23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PokeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PokeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PokeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PokeWidgetAttributes {
    fileprivate static var preview: PokeWidgetAttributes {
        PokeWidgetAttributes(name: "World")
    }
}

extension PokeWidgetAttributes.ContentState {
    fileprivate static var smiley: PokeWidgetAttributes.ContentState {
        PokeWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PokeWidgetAttributes.ContentState {
         PokeWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PokeWidgetAttributes.preview) {
   PokeWidgetLiveActivity()
} contentStates: {
    PokeWidgetAttributes.ContentState.smiley
    PokeWidgetAttributes.ContentState.starEyes
}
