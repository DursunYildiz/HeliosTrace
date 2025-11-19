import Combine
import SwiftUI

final class NetworkViewModel: ObservableObject {
    @Published var models: [HttpModel] = []
    @Published var cacheModels: [HttpModel] = []
    @Published var filteredModels: [HttpModel] = []
    @Published var searchText: String = HeliosTraceSettings.shared.networkSearchWord ?? ""
    @Published var reloadDataFinish: Bool = true
    @Published var reachEnd: Bool = true
    @Published var firstIn: Bool = true

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        observeReload()
        reloadHttp(needScrollToEnd: true)
    }

    // MARK: - Observer (Combine)

    private func observeReload() {
        NotificationCenter.default.publisher(for: .reloadHttpHeliosTrace)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.reloadHttp(needScrollToEnd: self.reachEnd)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func reloadHttp(needScrollToEnd: Bool = false) {
        guard reloadDataFinish else { return }

        models = (HttpDatasource.shared.httpModels as NSArray as? [HttpModel]) ?? []
        cacheModels = models

        searchLogic(HeliosTraceSettings.shared.networkSearchWord ?? "")
        reloadDataFinish = false

        DispatchQueue.main.async {
            self.reloadDataFinish = true
        }
    }

    func searchLogic(_ text: String = "") {
        if text.isEmpty {
            filteredModels = cacheModels
        } else {
            let lower = text.lowercased()
            filteredModels = cacheModels.filter {
                $0.url?.absoluteString.lowercased().contains(lower) ?? false
            }
        }
    }

    func tapTrash() {
        HttpDatasource.shared.reset()
        models.removeAll()
        cacheModels.removeAll()
        filteredModels.removeAll()
        HeliosTraceSettings.shared.networkLastIndex = 0

        NotificationCenter.default.post(
            name: Notification.Name("deleteAllLogs_HeliosTrace"),
            object: nil
        )
    }

    func onSearchTextChange(_ newValue: String) {
        HeliosTraceSettings.shared.networkSearchWord = newValue
        searchLogic(newValue)
    }

    var titleText: String {
        "🚀[\(filteredModels.count)]"
    }
}
