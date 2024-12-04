//
//  NetworkManager.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/3/24.
//

import OpenAISwift
import SwiftUI
import Foundation

class NetworkManager {
    func sendRequest(_ request: URLRequest) async throws -> Data {
        let (responseData, _) = try await URLSession.shared.data(for: request)
        return responseData
    }
}

