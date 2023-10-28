import Foundation

class GenericNetworkCall {
    let apiHandler : ApiHandler
    let responseHandler : ResponseHandler
    
    init(apiHandler: ApiHandler = ApiHandler(), responseHandler: ResponseHandler = ResponseHandler()) {
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }
    
    func fetchData<T : Codable>(url: String, method: String, params:[String:Any]?, responseClass: T.Type , completion:@escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.requestFailed))
            return
        }
        self.apiHandler.fetchData(url: url, method: method) { result in
            switch result{
            case .success(let data):
                self.responseHandler.fetchModel(data: data,responseClass: T.self) { decodedResult in
                    switch decodedResult {
                    case .success(let model):
                        completion(.success(model))
                    case.failure(let error):
                        debugPrint(error)
                        completion(.failure(.decodingError))
                    }
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
                completion(.failure(.invalidData))
            }
        }
    }
}

class ApiHandler {
    func fetchData(url: URL?, method: String, completion:@escaping (Result<Data, APIError>) -> Void) {
        guard let url = url else {
            completion(.failure(.requestFailed))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}

class ResponseHandler {
    func fetchModel<T : Codable>(data : Data,responseClass: T.Type, completion:@escaping (Result<T, APIError>) -> Void) {
        DispatchQueue.main.async {
            do {
                let mappedModel = try JSONDecoder().decode(T.self, from: data)
                completion(.success(mappedModel))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }
}
