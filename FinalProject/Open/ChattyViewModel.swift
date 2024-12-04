//
//  ChattyViewModel.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/3/24.
//

import OpenAISwift
import SwiftUI
import Foundation

enum KeyConstants {
  static func loadAPIKeys() async throws  {
    let request = NSBundleResourceRequest(tags: ["APIKey"])
    try await request.beginAccessingResources()

    let url = Bundle.main.url(forResource: "APIKey", withExtension: "json")!
    let data = try Data(contentsOf: url)
    // TODO: Store in keychain and skip NSBundleResourceRequest on next launches
    APIKeys.storage = try JSONDecoder().decode([String: String].self, from: data)

    request.endAccessingResources()
  }

  enum APIKeys {
    static fileprivate(set) var storage = [String: String]()
    

    static var mySecretAPIKey: String { storage["AI_KEY"] ?? "" }
  }
}

struct ChatMessage: Identifiable {
    var id = UUID()
    var message: String
    var isUser: Bool
}

final class ChattyViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [] // Published property for chat messages

    private var openAI: OpenAISwift?

    init() {}

    func setupOpenAI() {
        print("\(KeyConstants.APIKeys.mySecretAPIKey)")
        print("\(KeyConstants.APIKeys.storage)")
        print("intialized")
        let config: OpenAISwift.Config = .makeDefaultOpenAI(apiKey: KeyConstants.APIKeys.mySecretAPIKey)
        openAI = OpenAISwift(config: config) // Initialize OpenAI
    }

    func sendUserMessage(_ message: String) {
        let userMessage = ChatMessage(message: message, isUser: true)
        messages.append(userMessage) // Append user message to chat history

        openAI?.sendCompletion(with: message, maxTokens: 500) { [weak self] result in
            switch result {
            case .success(let model):
                if let response = model.choices?.first?.text {
                    self?.receiveBotMessage(response) // Handle bot's response
                }
            case .failure(_):
                // Handle any errors during message sending
                break
            }
        }
    }

    private func receiveBotMessage(_ message: String) {
        let botMessage = ChatMessage(message: message, isUser: false)
        messages.append(botMessage) // Append bot message to chat history
    }
}

//#Preview {
//    ChattyViewModel()
//}
