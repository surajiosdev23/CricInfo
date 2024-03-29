//
//  TeamsViewModel.swift
//  MyCricInfo

import Foundation

protocol fetchPlayers {
    func fetchPlayerData(matchUrl : String,completion: @escaping (Swift.Result<DataModel?, Error>) -> Void)
}
class TeamsViewModel : fetchPlayers{
    let network = GenericNetworkCall()
    private var players = [Player]()
    
    func fetchPlayerData(matchUrl : String,completion: @escaping (Swift.Result<DataModel?, Error>) -> Void) {
        network.fetchData(url: matchUrl, method: "GET", params: [:], responseClass: DataModel.self) { result in
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    debugPrint("Error fetching player data:", error)
                    completion(.failure(error))
                }
            }
        }
}
