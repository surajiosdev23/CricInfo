//
//  TeamsViewModel.swift
//  MyCricInfo

import Foundation

class TeamsViewModel{
    
    let network = GenericNetworkCall()
    func getResponseData(matchUrl : String,completion: @escaping
                         (Swift.Result<DataModel?, GenericNetworkCall.ErrorPOJO>) -> Void) {
        network.fetchData(url: matchUrl, method: "get", params: [String : Any](), responseClass: DataModel.self) { (response) in
            switch response {
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                print("ERROR \(err)")
                completion(.failure(err))
            }
        }
    }
}

