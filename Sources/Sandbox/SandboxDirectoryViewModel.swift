//
//  SandboxDirectoryViewModel.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 13.11.2025.
//

import Combine
import Foundation

final class SandboxDirectoryViewModel: ObservableObject, Identifiable {
    let id: String
    let url: URL

    @Published private(set) var items: [SandboxItem] = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let manager: SandboxManager
    private let helper: SandboxHelper
    private let searchStorageKey: String

    init(url: URL, manager: SandboxManager = .shared, helper: SandboxHelper = .shared, searchStorageKey: String? = nil) {
        self.url = url
        self.manager = manager
        self.helper = helper
        self.id = UUID().uuidString
        let key = searchStorageKey ?? helper.generateRandomIdentifier()
        self.searchStorageKey = key
        self.searchText = helper[searchKey: key] ?? ""

        setupBindings()
        Task { await load() }
    }

    deinit {
        helper[searchKey: searchStorageKey] = searchText
    }

    func load() async {
        isLoading = true
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        errorMessage = nil

        let result = await Task.detached(priority: .userInitiated) { [manager] in
            manager.contents(of: self.url)
        }.value

        if Task.isCancelled { return }
        Task { @MainActor in
            items = result
        }
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }

        let result = await Task.detached(priority: .userInitiated) { [manager] in
            manager.refreshContents(of: self.url)
        }.value

        if Task.isCancelled { return }
        items = result
    }

    func deleteItems(at offsets: IndexSet) {
        let targets = offsets.map { filteredItems[$0] }
        Task {
            for item in targets {
                do {
                    try manager.delete(item)
                } catch {
                    errorMessage = error.localizedDescription
                    return
                }
            }
            await refresh()
        }
    }

    func rename(item: SandboxItem, to newName: String) {
        Task {
            do {
                try manager.rename(item, to: newName)
                await refresh()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    var filteredItems: [SandboxItem] {
        guard !searchText.isEmpty else { return items }
        return items.filter { item in
            item.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var title: String {
        if url == manager.homeURL {
            return manager.homeTitle
        }

        let displayName = url.lastPathComponent
        return displayName.isEmpty ? manager.homeTitle : displayName
    }

    var supportsDeletion: Bool {
        manager.isFileDeletable || manager.isDirectoryDeletable
    }

    // MARK: - Private

    private func setupBindings() {
        $searchText
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self else { return }
                helper[searchKey: searchStorageKey] = newValue
            }
            .store(in: &cancellables)
    }
}
