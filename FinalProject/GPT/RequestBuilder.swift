//
//  RequestBuilder.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/4/24.
//

import Foundation

class RequestBuilder {
    
    func buildRequest(prompt: String, url: URL?, apiKey: String) -> URLRequest? {
        guard let apiUrl = url else { return nil }
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("unable to serialize")
            return nil
        }
        request.httpBody = jsonData
        return request
        
    }
}
