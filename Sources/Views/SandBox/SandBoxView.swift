//
//  SandBoxView.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 13.11.2025.
//

import SwiftUI

#if canImport(UIKit)
  import UIKit
#endif

struct SandBoxView: View {
  @StateObject private var viewModel = SandboxDirectoryViewModel(url: SandboxManager.shared.homeURL)

  var body: some View {
    NavigationStackWrapper {
      SandboxDirectoryListView(viewModel: viewModel)
    }
  }
}

private struct SandboxDirectoryListView: View {
  @ObservedObject var viewModel: SandboxDirectoryViewModel

  var body: some View {
    List {
      ForEach(viewModel.filteredItems) { item in
        row(for: item)
      }
      .onDelete(perform: viewModel.supportsDeletion ? viewModel.deleteItems : nil)
    }
    .listStyle(.plain)
    .overlay(emptyStateOverlay)
    .animation(.default, value: viewModel.filteredItems)
    .navigationTitle(viewModel.title)
    .toolbar { refreshToolbar }
    .overlay(loadingOverlay)
    .conditionalSearchBar(text: $viewModel.searchText, placeholder: "Search Files")
    .alert(
      isPresented: Binding(
        get: { viewModel.errorMessage != nil },
        set: { if !$0 { viewModel.errorMessage = nil } }
      )
    ) {
      Alert(
        title: Text("Sandbox Error"),
        message: Text(viewModel.errorMessage ?? ""),
        dismissButton: .default(Text("OK")) {
          viewModel.errorMessage = nil
        }
      )
    }
  }

  @ToolbarContentBuilder
  private var refreshToolbar: some ToolbarContent {
    ToolbarItem(placement: .topBarTrailing) {
      Button {
        Task { await viewModel.refresh() }
      } label: {
        if viewModel.isLoading {
          ProgressView()
        } else {
          Image(systemName: "arrow.clockwise")
        }
      }
      .disabled(viewModel.isLoading)
    }
  }

  @ViewBuilder
  private func row(for item: SandboxItem) -> some View {
    if item.isDirectory {
      NavigationLink {
        SandboxDirectoryListView(viewModel: SandboxDirectoryViewModel(url: item.url))
      } label: {
        SandboxItemRow(item: item)
      }
    } else {
      SandboxItemRow(item: item)
    }
  }

  @ViewBuilder
  private var loadingOverlay: some View {
    if viewModel.isLoading && viewModel.items.isEmpty {
      ProgressView()
        .progressViewStyle(.circular)
    }
  }

  @ViewBuilder
  private var emptyStateOverlay: some View {
    if viewModel.items.isEmpty && !viewModel.isLoading {
      if #available(iOS 17.0, *) {
        ContentUnavailableView(
          "Empty Directory", systemImage: "shippingbox",
          description: Text("There are no files or folders here.")
        )
      } else {
        VStack(spacing: 12) {
          Image(systemName: "shippingbox")
            .font(.system(size: 32, weight: .regular))
            .adaptiveForegroundStyle(.secondary)
          Text("Empty Directory")
            .font(.headline)
          Text("There are no files or folders here.")
            .font(.subheadline)
            .adaptiveForegroundStyle(.secondary)
        }
        .padding(.top, 64)
      }
    }
  }
}

private struct SandboxItemRow: View {
  let item: SandboxItem

  var body: some View {
    HStack(spacing: 12) {
      icon
        .frame(width: 28, height: 28)

      VStack(alignment: .leading, spacing: 4) {
        Text(item.displayName)
          .font(.subheadline)
          .fontWeight(.semibold)
          .lineLimit(2)
          .truncationMode(.middle)

        Text(item.modificationDateText)
          .font(.caption)
          .adaptiveForegroundStyle(.secondary)
      }

      Spacer(minLength: 0)

      if item.isDirectory {
        Text("\(item.childCount)")
          .font(.caption2)
          .adaptiveForegroundStyle(.secondary)
          .padding(.horizontal, 6)
          .padding(.vertical, 2)
          .background(Color.secondary.opacity(0.1))
          .clipShape(RoundedRectangle(cornerRadius: 4))
      }
    }
    .padding(.vertical, 4)
  }

  @ViewBuilder
  private var icon: some View {
    #if canImport(UIKit)
      if let image = UIImage(named: item.iconName, in: Bundle.main, with: nil) {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .clipShape(RoundedRectangle(cornerRadius: 4))
      } else {
        defaultIcon
      }
    #else
      defaultIcon
    #endif
  }

  private var defaultIcon: some View {
    Image(systemName: item.isDirectory ? "folder" : "doc")
      .font(.system(size: 20, weight: .medium))
      .foregroundColor(.accentColor)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
