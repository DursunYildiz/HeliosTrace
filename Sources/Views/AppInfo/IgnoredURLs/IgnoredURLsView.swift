//
//  IgnoredURLsView.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 12.11.2025.
//

import SwiftUI

// MARK: - View

struct IgnoredURLsView: View {
    @StateObject private var viewModel = IgnoredURLsViewModel()

    var body: some View {
        List {
            ForEach(viewModel.sections.indices, id: \.self) { sectionIndex in
                Section(header: Text(viewModel.sections[sectionIndex].title)
                    .font(.headline)
                    .padding(.vertical, 8)
                ) {
                    ForEach(viewModel.sections[sectionIndex].items, id: \.self) { item in
                        Text(item)
                            .font(.subheadline)
                            .foregroundColor(.primaryColor)
                            .lineLimit(1)
                            .padding(.vertical, 4)
                    }
                }
            }

            .listStyle(.automatic)
            .navigationTitle("Settings")
        }
    }
}

