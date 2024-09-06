//
//  QuoteFetcher.swift
//  habitTracker
//
//  Created by Djordje Arandjelovic on 21.8.24..
//

import Foundation

struct Quote: Codable {
    let q: String
    let a: String
}

class QuoteFetcher {
    static func fetchMotivationalQuote(completion: @escaping (String) -> Void) {
        let url = URL(string: "https://zenquotes.io/api/today")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Filed to fetch data:", error?.localizedDescription ?? "Unknown error")
                completion("Stay motivated!")
                return
            }
            
            if let quote = try? JSONDecoder().decode([Quote].self, from: data).first {
                completion("\"\(quote.q)\" - \(quote.a)")
            } else {
                completion("Stay motivated!")
            }
        }.resume()
    }
}
