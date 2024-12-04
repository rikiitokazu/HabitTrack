//
//  AIService.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/4/24.
//

import Foundation

let Initial_Prompt = "You will get a daily goal that a user would like to accomplish. No matter what they ask, you will return the following. Habit: followed by the name of the habit that the user should do. This should be no more than 7 words long. Frequency: followed by a number from 1-5 that represents how often they should do their habit per day to obtain a goal. After you provide the number, write (per/day) in parenthesis as specified. Then, provide a brief 1 detailed sentence description about the steps to take to achieve their goals. This should be short, concise, and straight to the point. Less than 15 words. So, you should give the Habit, Frequency, as well as a brief sentence on how to achieve the goal."

class AIService {
    private let networkManager = NetworkManager()
    private let requestBuilder = RequestBuilder()
    private let errorMessage = "Error: Unable to generate AI response"
    private let url = URL(string: "https://api.openai.com/v1/chat/completions")
    
    func getAIResponse(prompt: String, key: String) async -> String {
        let newPrompt = Initial_Prompt + prompt
        guard let request = requestBuilder.buildRequest(prompt: newPrompt, url: url, apiKey: key) else {
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
