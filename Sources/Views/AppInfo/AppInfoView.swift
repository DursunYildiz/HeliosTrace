import SwiftUI

// MARK: - View

struct AppInfoView: View {
    @StateObject private var viewModel = AppInfoViewModel()
    
    var body: some View {
        NavigationStackWrapper {
            Form {
                Section(header: Text("App Info")) {
                    ForEach(viewModel.appInfoFields(), id: \.title) { field in
                        copyableRow(title: field.title, value: field.value)
                    }
                }
                
                Section(header: Text("Device Info")) {
                    ForEach(viewModel.deviceInfoFields(), id: \.title) { field in
                        HStack {
                            Text(field.title)
                            Spacer()
                            Text(field.value)
                                .foregroundColor(field.title == "Crash Count" && Int(field.value) ?? 0 > 0 ? .red : .secondary)
                        }
                    }
                }
                
                Section(header: Text("Settings")) {
                    toggleRow("Log Monitoring", isOn: $viewModel.logMonitoring, action: viewModel.toggleLogMonitoring)
                    toggleRow("Network Monitoring", isOn: $viewModel.networkMonitoring, action: viewModel.toggleNetworkMonitoring)
                    toggleRow("RN Monitoring", isOn: $viewModel.rnMonitoring, action: viewModel.toggleRNMonitoring)
                    toggleRow("WebView Monitoring", isOn: $viewModel.webViewMonitoring, action: viewModel.toggleWebViewMonitoring)
                    toggleRow("Slow Animations", isOn: $viewModel.slowAnimations, action: viewModel.toggleSlowAnimations)
                    toggleRow("Crash Recording", isOn: $viewModel.crashRecording, action: viewModel.toggleCrashRecording)
                    toggleRow("UI Blocking", isOn: $viewModel.uiBlocking, action: viewModel.toggleUIBlocking)
                }
                Section(header: Text("IgnoredURLs")) {
                    NavigationLink {
                        IgnoredURLsView()
                    } label: {
                        Text("IgnoredURLs")
                    }
                }
            }
            .navigationTitle("App Info")
            .alert(isPresented: $viewModel.showRestartAlert) {
                Alert(
                    title: Text("Restart Required"),
                    message: Text("You must restart the app to ensure the changes take effect."),
                    primaryButton: .destructive(Text("Restart now")) { exit(0) },
                    secondaryButton: .cancel(Text("Restart later"))
                )
            }
            .sheet(isPresented: $viewModel.showClipboardSheet) {
                ActivityView(activityItems: [viewModel.clipboardContent])
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func toggleRow(_ title: String, isOn: Binding<Bool>, action: @escaping (Bool) -> Void) -> some View {
        Toggle(title, isOn: isOn)
            .onChange(of: isOn.wrappedValue) { newValue in
                action(newValue)
            }
    }
    
    private func copyableRow(title: String, value: String) -> some View {
        Button {
            viewModel.copyToClipboard(value)
        } label: {
            HStack {
                Text(title)
                Spacer()
                Text(value)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

