import Foundation

// Class responsible for making generic network calls
class GenericNetworkCall {
    
    let apiHandler : ApiHandlerDelegate
    let responseHandler : ResponseHanlderDelegate
    
    // Initialize with default implementations of apiHandler and responseHandler
    init(apiHandler: ApiHandlerDelegate = ApiHandler(), responseHandler: ResponseHanlderDelegate = ResponseHandler()) {
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }
    
    // Function to fetch data from a URL
    func fetchData<T : Codable>(
        url: String,
        method: String,
        params:[String:Any]?,
        responseClass: T.Type,
        completion:@escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: url) else {
            completion(.failure(.requestFailed)) // Notify if URL is invalid
            return
        }
        
        // Use apiHandler to perform the network call
        self.apiHandler.fetchData(url: url, method: method) { result in
            switch result {
            case .success(let data):
                // Use responseHandler to decode the received data
                self.responseHandler.fetchModel(data: data, responseClass: T.self) { decodedResult in
                    switch decodedResult {
                    case .success(let model):
                        completion(.success(model)) // Provide the decoded model to the completion handler
                    case.failure(let error):
                        debugPrint(error) // Print and notify if decoding error occurs
                        completion(.failure(.decodingError))
                    }
                }
            case .failure(let error):
                debugPrint(error.localizedDescription) // Print and notify if network request fails
                completion(.failure(.invalidData))
            }
        }
    }
}

// Protocol defining the behavior of an API handler
protocol ApiHandlerDelegate {
    func fetchData(url: URL?, method: String, completion:@escaping (Result<Data, APIError>) -> Void)
}

// Default implementation of ApiHandlerDelegate
class ApiHandler : ApiHandlerDelegate {
    func fetchData(url: URL?, method: String, completion:@escaping (Result<Data, APIError>) -> Void) {
        guard let url = url else {
            completion(.failure(.requestFailed)) // Notify if URL is invalid
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.invalidData)) // Notify if received data is invalid
                return
            }
            completion(.success(data)) // Provide the received data to the completion handler
        }
        task.resume()
    }
}

// Protocol defining the behavior of a response handler
protocol ResponseHanlderDelegate {
    func fetchModel<T : Codable>(data : Data,responseClass: T.Type, completion:@escaping (Result<T, APIError>) -> Void)
}

// Default implementation of ResponseHanlderDelegate
class ResponseHandler: ResponseHanlderDelegate {
    func fetchModel<T : Codable>(data : Data,responseClass: T.Type, completion:@escaping (Result<T, APIError>) -> Void) {
        DispatchQueue.main.async {
            do {
                let mappedModel = try JSONDecoder().decode(T.self, from: data)
                completion(.success(mappedModel)) // Provide the decoded model to the completion handler
            } catch {
                completion(.failure(.decodingError)) // Notify if decoding error occurs
            }
        }
    }
}
