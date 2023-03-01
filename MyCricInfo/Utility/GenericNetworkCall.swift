

import Foundation
import Alamofire

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}
struct CommonError : Codable{
    var error: String?
    var message: String?
}
enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}
class GenericNetworkCall {
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, params:[String:Any], responseClass: T.Type , completion:@escaping (Swift.Result<T?, ErrorPOJO>) -> Void) {
        var encode: ParameterEncoding?
        let headers = HTTPHeaders()
        if method == .get || method == .delete
        {
            encode = URLEncoding.default
        }else {
            encode = JSONEncoding.default
        }
        print("URL : \(url)")
        print("params : \(params)")
        AF.request(url, method: method, parameters: params, encoding: encode!, headers: headers).responseJSON { (response) in
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 { // success
                    guard let jsonResponse = try? response.result.get() else { return }
                    guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else { return }
                    do {
                    let responseObj = try JSONDecoder().decode(T.self, from: theJSONData)
                    completion(.success(responseObj))
                    }catch let error {
                        print("fetchData catch: \(error.localizedDescription)")
                        let err = ErrorPOJO(message: error.localizedDescription)
                        completion(.failure(err))
                    }
                } else {
                    guard let jsonResponse = try? response.result.get() else { return }
                    guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else { return }
                    do {
                        let responseObj = try JSONDecoder().decode(ErrorPOJO.self, from: theJSONData)
                        completion(.failure(responseObj))
//                        completion(.success(responseObj))
                        
                    }
                    catch let error {
                        print("fetchData failure: \(error)")
                        completion(.failure(error as! GenericNetworkCall.ErrorPOJO))
                    }
                }
            }
        }
    
    func authenticateToken<T: Decodable>(url: String, method: HTTPMethod, params:[String:Any], responseClass: T.Type , completion:@escaping (Swift.Result<T?, ErrorPOJO>) -> Void) {
        var encode: ParameterEncoding?
//        let headers: HTTPHeaders = [
//            "Authorization" : "Bearer \(String(describing: getUserdefaultDataForKey(Key: APP_LOGIN_TOKEN) ?? ""))"
//        ]
        let credentialData = "\(params["user"]!):\(params["pass"]!)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers : HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        
        if method == .get || method == .delete
        {
            encode = URLEncoding.default
        }else {
            encode = JSONEncoding.default
        }
        AF.requestWithoutCache(url, method: method, parameters: params, encoding: encode!, headers: headers).responseJSON
        { (response) in
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 { // Success
                    guard let jsonResponse = try? response.result.get() else { return }
                    guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else { return }
                    do {
                    let responseObj = try JSONDecoder().decode(T.self, from: theJSONData)
                    completion(.success(responseObj))
                    }catch let error {
                        print("Error hdgfhs: \(error.localizedDescription)")
                        let err = ErrorPOJO(message: error.localizedDescription)
                        completion(.failure(err))
                    }
                } else {
                    guard let jsonResponse = try? response.result.get() else { return }
                    guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else { return }
                    do {
                        let responseObj = try JSONDecoder().decode(ErrorPOJO.self, from: theJSONData)
                        completion(.failure(responseObj))
                        
                    }
                    catch let error {
                        print("authenticateToken failure: \(error)")
                        completion(.failure(error as! GenericNetworkCall.ErrorPOJO))
                    }
                }
            }
        }
    
    struct ErrorPOJO: Error, Codable {
        var message: String?
    }
}

extension Alamofire.Session{
    @discardableResult
    public func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)// also you can add URLRequest.CachePolicy here as parameter
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            // TODO: find a better way to handle error
            print(error)
            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}
