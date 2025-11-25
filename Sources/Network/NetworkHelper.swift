import UIKit

final class NetworkHelper {

    // MARK: - Singleton
    static let shared = NetworkHelper()

    // MARK: - Properties

    /// Color for UI/logging
    var mainColor: UIColor

    /// Domain names to ignore (case-insensitive)
    var ignoredURLs: [String]?

    /// Only these domain names are allowed (case-insensitive)
    var onlyURLs: [String]?

    /// Log prefixes to ignore
    var ignoredPrefixLogs: [String]?

    /// Log prefixes to allow
    var onlyPrefixLogs: [String]?

    /// Protobuf transfer mapping
    var protobufTransferMap: [String: [String]]?

    /// Enable/Disable network logging
    private(set) var isNetworkEnable: Bool

    // MARK: - Init

    private init() {
        self.mainColor = UIColor(hex: "#42d459")
        self.ignoredURLs = []
        self.onlyURLs = []
        self.ignoredPrefixLogs = []
        self.onlyPrefixLogs = []
        self.protobufTransferMap = [:]
        self.isNetworkEnable = false
    }

    // MARK: - Methods

    func enable() {
        guard !isNetworkEnable else { return }
        isNetworkEnable = true
        CustomHTTPProtocol.start()
        URLSession.enableHeliosTraceSwizzling()
    }

    func disable() {
        guard isNetworkEnable else { return }
        isNetworkEnable = false
        CustomHTTPProtocol.stop()
        URLSession.disableHeliosTraceSwizzling()
    }
}
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
