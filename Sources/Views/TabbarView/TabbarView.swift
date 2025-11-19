//
//  TabbarView.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 11.11.2025.
//

import SwiftUI

public struct TabbarView: View {
  @Environment(\.safeDismiss) private var dismiss
  @AppStorage(appThemeStorageKey) private var themeRaw: String = AppTheme.dark.rawValue

  private var currentTheme: AppTheme {
    AppTheme(rawValue: themeRaw) ?? .system
  }

  public init() {}

  public var body: some View {
    TabView {
      ContentView()
        .tabItem {
          Image(systemName: "house.fill")
          Text("Home")
        }

      LogsTabView()
        .tabItem {
          Image(systemName: "doc.text.magnifyingglass")
          Text("Logs")
        }

      NetworkView()
        .tabItem {
          Image(systemName: "antenna.radiowaves.left.and.right")
          Text("Network")
        }.withSafeDismiss()

      SandBoxView()
        .tabItem {
          Image(systemName: "shippingbox")
          Text("Sandbox")
        }

      //            SettingsTabView(themeRaw: $themeRaw)
      //                .tabItem {
      //                    Image(systemName: "gearshape.fill")
      //                    Text("Settings")
      //                }
      AppInfoView()
        .tabItem {
          Image(systemName: "gearshape.fill")
          Text("Settings")
        }
    }
    .onDisappear {
      WindowHelper.shared.displayedList = false
    }
    .preferredColorScheme(currentTheme.colorScheme)
  }
}

private struct HomeTabView: View {
  var body: some View {
    NavigationStackWrapper {
      Text("Home")
        .font(.title)
        .navigationTitle("Home")
    }
  }
}

private struct LogsTabView: View {
  var body: some View {
    NavigationStackWrapper {
      Text("Logs")
        .font(.title)
        .navigationTitle("Logs")
    }
  }
}

private struct NetworkTabView: View {
  var body: some View {
    NavigationStackWrapper {
      Text("Network")
        .font(.title)
        .navigationTitle("Network")
    }
  }
}

private struct SettingsTabView: View {
  @Binding var themeRaw: String

  var body: some View {
    NavigationStackWrapper {
      //            Form {
      //                Section("Appearance") {
      //                    Picker("Theme", selection: $themeRaw) {
      //                        ForEach(AppTheme.allCases) { theme in
      //                            Text(theme.title).tag(theme.rawValue)
      //                        }
      //                    }
      //                }
      //            }
      //            .navigationTitle("Settings")
    }
  }
}

