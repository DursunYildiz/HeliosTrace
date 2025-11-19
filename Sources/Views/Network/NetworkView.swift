//
//  NetworkView.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 11.11.2025.
//

import SwiftUI

struct NetworkView: View {
    @Environment(\.safeDismiss) private var dismiss
    @StateObject private var viewModel = NetworkViewModel()

    var body: some View {
        NavigationStackWrapper {
            ScrollViewReader { proxy in
                List(viewModel.filteredModels.indices, id: \.self) { index in
                    let model = viewModel.filteredModels[index]
                    NavigationLink {
                        NetworkDetailView(model: model, allModels: viewModel.filteredModels)
                    } label: {
                        NetworkRow(index: index, model: model)
                    }
                    .id(index)
                }
                .listStyle(.plain)
                .onChange(of: viewModel.filteredModels.count) { _ in
                    if viewModel.reachEnd {
                        scrollToBottom(proxy: proxy, animated: !viewModel.firstIn)
                        viewModel.firstIn = false
                    }
                }
                .onChange(of: viewModel.searchText) { newValue in
                    viewModel.onSearchTextChange(newValue)
                }

                .navigationTitle(viewModel.titleText)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button {
                            scrollToTop(proxy: proxy)
                            dismissKeyboard()
                            viewModel.reachEnd = false
                            HeliosTraceSettings.shared.networkLastIndex = 0
                        } label: {
                            Image(systemName: "arrow.up.to.line")
                        }
                        Button {
                            scrollToBottom(proxy: proxy)
                            dismissKeyboard()
                            viewModel.reachEnd = true
                            HeliosTraceSettings.shared.networkLastIndex = 0
                        } label: {
                            Image(systemName: "arrow.down.to.line")
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            viewModel.tapTrash()
                        } label: {
                            Image(systemName: "trash")
                        }
                        .adaptiveForegroundStyle(.green)

                        Button {
                            WindowHelper.shared.displayedList = false
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .onAppear {
                    configureSearchAppearance()
                    let lastIndex = HeliosTraceSettings.shared.networkLastIndex
                    if lastIndex > 0, lastIndex < viewModel.filteredModels.count {
                        withAnimation(nil) {
                            proxy.scrollTo(lastIndex, anchor: .bottom)
                        }
                    }
                }
                .onDisappear {
                    dismissKeyboard()
                }

                // MARK: - Search

                .conditionalSearchBar(text: $viewModel.searchText, placeholder: "Search Logs")
            }
        }
    }

    // MARK: - Helpers

    private func scrollToTop(proxy: ScrollViewProxy, animated: Bool = true) {
        guard viewModel.filteredModels.count > 0 else { return }
        if animated {
            withAnimation { proxy.scrollTo(0, anchor: .top) }
        } else {
            proxy.scrollTo(0, anchor: .top)
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool = true) {
        guard viewModel.filteredModels.count > 0 else { return }
        let last = viewModel.filteredModels.count - 1
        if animated {
            withAnimation { proxy.scrollTo(last, anchor: .bottom) }
        } else {
            proxy.scrollTo(last, anchor: .bottom)
        }
    }

    private func dismissKeyboard() {
        #if canImport(UIKit)
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        #endif
    }

    private func configureSearchAppearance() {
        // Opsiyonel: UISearchBar özelleştirme (iOS 14)
    }
}

// MARK: - Search Bar Compatibility

extension View {
    @ViewBuilder
    func conditionalSearchBar(text: Binding<String>, placeholder: String) -> some View {
        if #available(iOS 15.0, *) {
            self.searchable(
                text: text, placement: .navigationBarDrawer(displayMode: .always), prompt: placeholder
            )
        } else {
            overlay(SearchBarView(text: text, placeholder: placeholder))
        }
    }
}

// MARK: - UISearchBar Wrapper (iOS 14)

struct SearchBarView: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBarView

        init(_ parent: SearchBarView) {
            self.parent = parent
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }
    }
}

// MARK: - Row

private struct NetworkRow: View {
    let index: Int
    let model: HttpModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text("#\(index + 1)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 4))

                // URL
                Text(model.url?.absoluteString ?? "-")
                    .font(.system(size: 13, weight: .bold))
                    .lineLimit(3)
                    .adaptiveForegroundStyle(.primaryColor)
            }

            HStack(spacing: 8) {
                // Status code
                if let code = model.statusCode {
                    Text("#\(code)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(model.statusColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(model.statusColor.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }

                // HTTP Method
                if let method = model.method {
                    Text(method)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(model.methodColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(model.methodColor.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }

                Spacer(minLength: 0)
            }
        }
        .padding(.vertical, 6)
    }
}
