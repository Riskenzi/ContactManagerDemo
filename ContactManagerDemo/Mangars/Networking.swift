//
//  Networking.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 30.10.2020.
//

import Foundation
class Networking : NSObject {
    
    
    private enum Log : String {
        case errorURl = "Log : Error URL ⚠️"
        case errorResponceURL = "Log : Error Responce URL ⚠️"
        case errorDecode = "Log : Error Decode ⚠️"
        case completionData = "Log : All Items -> ⚡️"
    }
     
    
    public let baseUrl = "https://randomuser.me/"
    //https://randomuser.me/api/?results=20
    
    enum APIVersion : String {
        case api = "api/"
    }
    
    enum APIRequest: String {
        case contacts = "?results="
    }
    
    enum APIRequestLimitItems : String {
        case items_20 = "20"
    }
    
    enum Result<T,E:Error> {
        case success(T)
        case failture(E)
    }
    

    typealias featchCompletion = ((Result<Model,NetworkingError>)->Void)

    static let shared: Networking = Networking()
    
    private var task: URLSessionTask?
    private let session = URLSession.shared
    
    // MARK: - Life cycle
    
    private override init() {
        super.init()
    }

    
    public func getContactsHandler(completion: @escaping featchCompletion) {
        guard let url = URL(string: "\(baseUrl)\(APIVersion.api.rawValue)\(APIRequest.contacts.rawValue)\(APIRequestLimitItems.items_20.rawValue)") else {  fatalError(Log.errorURl.rawValue)  }
        
        if let task = task {
            task.cancel()
        }
        
        task = session.dataTask(with: url) { data, response, err in
            if(err != nil) {
                completion(.failture(.invalidResponse))
            }
            guard let httpResponse = response as? HTTPURLResponse else {  completion(.failture(.invalidResponse))
                return
            }
            switch httpResponse.statusCode {
            case 200:
                if let data = data {
                    do {
                        let data = try JSONDecoder().decode(Model.self, from: data)
                        completion(.success(data))
                        print(Log.completionData.rawValue,data)
                    } catch {
                        print("\(Log.errorDecode.rawValue) \(err.debugDescription)")
                    }
                }
                break
            default:
                completion(.failture(.invalidRequest))
                break
            }
        }
        self.task?.resume()
    }
}

enum NetworkingError : String,Error {
    case invalidRequest = "You have made invalid request"
    case invalidResponse = "You have made invalid responce"
    case unableToDecode = "We could not decode the response."
}


extension NetworkingError: LocalizedError {
    var errorDescription: String? {return NSLocalizedString(rawValue, comment: "")}
}
