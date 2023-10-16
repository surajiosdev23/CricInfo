import Foundation

class GenericNetworkCall {
    func fetchData<T: Decodable>(url: String, method: String, params:[String:Any], responseClass: T.Type , completion:@escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.requestFailed))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // Add any additional headers or parameters here
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestFailed))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(.responseUnsuccessful))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                do {
                    let mappedModel = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(mappedModel))
                } catch {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
}
