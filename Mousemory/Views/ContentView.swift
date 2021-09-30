//
//  ContentView.swift
//  Mousemory
//
//  Created by @rezigned on 11/9/2564 BE.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("highlight.enabled") private var enabled = UserSettings.Highlight.defaultEnabled
    @AppStorage("highlight.size") private var size = UserSettings.Highlight.defaultSize
    @AppStorage("highlight.color") private var color =
        UserSettings.Highlight.defaultColor
    @AppStorage("settings.delay") private var delay: Double = UserSettings.delay

    var body: some View {
        VStack {
            Section {
                Text("Highlight")
                    .bold()
                    .frame(alignment: .trailing)
                Form {
                    Toggle("Show highlight", isOn: $enabled)
                    Section {
                        HStack {
                            Slider(value: $size, in: 5...50) {
                                Text("Size:")
                            }
                            Text("(\(size, specifier: "%.0f"))")
                        }
                        ColorPicker("Color:", selection: $color)
                    }
                    .disabled(!enabled)
                }
            }.padding(.bottom)
            Divider()
            Section {
                Text("Sensitivity")
                    .bold()
                Form {
                    HStack {
                        Slider(value: $delay, in: 0...500) {
                            Text("Delay:")
                        }
                        Text("(\(delay, specifier: "%.0f"))")
                    }
                }
            }
        }
        .frame(maxWidth: 250, idealHeight: 200)
        .padding(10)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct AboutView: View {
    let model = About()

    var body: some View {
        VStack {
            Image("Logo", bundle: Bundle.main)
                .frame(width: 64, height: 64, alignment: .center)
            HStack {
                Text(model.name)
                    .bold()
                    .font(.system(size: 14))
                Text(model.version)
                    .font(.system(size: 12))
            }
            HStack {
                ForEach(model.links, id: \.id) { link in
                    Link(link.title, destination: link.url)
                    if link.id != model.links.last?.id {
                        Text("|")
                    }
                }
            }
        }
        .frame(
            minWidth: 200,
            maxHeight: 120
        )
        .padding(10)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
