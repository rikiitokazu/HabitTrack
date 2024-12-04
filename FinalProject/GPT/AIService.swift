//
//  AIService.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/4/24.
//

import Foundation

class AIService {
    private let networkManager = NetworkManager()
    private let requestBuilder = RequestBuilder()
    private let errorMessage = "Error: Unable to generate AI response"
    private let url = URL(string: "https://api.openai.com/v1/chat/completions")
    
    func getAIResponse(prompt: String, key: String) async -> String {
        guard let request = requestBuilder.buildRequest(prompt: prompt, url: url, apiKey: key) else {
            print("error failed to build request")
            return errorMessage
        }
        
        do {
            let data = try await networkManager.sendRequest(request)
            return decodeResponse(data)
        } catch {
            print("failed to send request: \(error.localizedDescription)")
            return errorMessage
        }
    }
    
    private func decodeResponse(_ data: Data) -> String {
        do {
            let aiResponse = try JSONDecoder().decode(AIResponse.self, from: data)
            return aiResponse.choices.first?.message.content ?? "No respose found"
        } catch {
            print("error failed to decode response")
            return errorMessage
        }
    }
}
