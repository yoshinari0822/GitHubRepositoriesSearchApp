//
//  HTTPClient.swift
//  GitHubSearchApp
//
//  Created by 金山義成 on 2024/02/01.
//

import SwiftUI

protocol HTTPClient{
    func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}

extension URLSession: HTTPClient{
    func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        let task = dataTask(with: urlRequest){ data, urlResponse, error in
            switch(data, urlResponse, error){
                
                //エラー取得時
            case (_, _, let error?):
                completion(Result.failure(error))
                
                //データ取得時
            case (let data?, let urlResponse as HTTPURLResponse,_):
                completion(Result.success((data, urlResponse)))
                
                //その他
            default:
                fatalError("invalid response combination\(String(describing: (data, urlResponse, error))).")
            }
        }
        
        task.resume()
    }
}


//class StubHTTPClient: HTTPClient{
//    var result: Result<(Data, HTTPURLResponse), Error> = .success((
//        Data(),
//        HTTPURLResponse(
//            url: URL(string: "https://example.com")!,
//            statusCode: 200,
//            httpVersion: nil,
//            headerFields: nil
//        )!
//    ))
//    
//    func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){[unowned self] in
//            completion(self.result)
//            
//        }
//    }
//}


class GitHubClient{
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func send<Request: GitHubRequest>(request: Request, completion: @escaping(Result<Request.Response, GitHubClientError>) -> Void){
        
        let urlRequest = request.buildURLRequest()
        
        httpClient.sendRequest(urlRequest){result in
            
            switch result{
            case .success((let data, let urlResponse)):
                do{
                    let response = try request.response(from: data, urlResponse: urlResponse)
                    completion(Result.success(response))
                    
                }
                catch let error as GitHubAPIError{
                    completion(Result.failure(.apiError(error)))
                    
                }
                catch{
                    completion(Result.failure(.responseParseError(error)))
                }
                
            case .failure(let error):
                completion(.failure(.connectionError(error)))
            }
        }
    }
}
