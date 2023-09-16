//
//  CoinsViewModel.swift
//  SwiftCoin
//
//  Created by Welliton da Conceicao de Araujo on 11/09/23.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coin = ""
    @Published var price = ""
    
    init() {
        fetchPrice(coin: "bitcoin")
    }
    
    func fetchPrice(coin: String) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let  data = data else  { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let value = jsonObject[coin] as? [String: Double] else {
                print("Failed to parce value...")
                return
            }
            
            guard let  price = value["usd"] else { return }
            
            DispatchQueue.main.async {
                print(Thread.current)
                self.coin = coin.capitalized
                self.price = "$\(price)"
            }
        }.resume()
    }
}
