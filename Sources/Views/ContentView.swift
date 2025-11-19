import SwiftUI

struct ContentView: View {
    @State private var responseText: String = "Henüz istek yapılmadı."

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)

            Text("Hello, world!")

            Button("Google Request At") {
                sendGoogleRequest()
            }

            Text(responseText)
                .font(.footnote)
                .padding()
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    /// Basit bir GET isteği yapan fonksiyon
    func sendGoogleRequest() {
        guard let url = URL(string: "https://dattebayo-api.onrender.com/characters/1") else {
            responseText = "Geçersiz URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    responseText = "Hata: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse {
                    responseText = "Durum Kodu: \(httpResponse.statusCode)"
                } else {
                    responseText = "Bilinmeyen yanıt"
                }
            }
        }
        task.resume()
    }
}

