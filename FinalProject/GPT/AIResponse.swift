//
//  AIResponse.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/4/24.
//

import Foundation

struct AIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

struct Choice: Codable {
    let index: Int
    let message: Message
    let logprobs: String?
    let finish_reason: String
}

struct Message: Codable {
    let role: String
    let content: String
}
