//
//  Request.swift
//  GitHubSearchApp
//
//  Created by 金山義成 on 2024/01/24.
//

import SwiftUI

protocol GitHubRequest{
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var path: String{ get }
    var method: HTTPMethod{ get }
    var queryItems: [URLQueryItem]{ get }
//    "PUTやPOSTなどを使う場合"
//    var body: Encodable? { get }
}

extension GitHubRequest{
    var baseURL:URL {
        return URL(string: "https://api.github.com")!
    }
    
    
    func buildURLRequest() -> URLRequest{
        
        //urlの作成
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(
            url: url, resolvingAgainstBaseURL: true
        )
        
        switch method{
        case .get:
            components?.queryItems = queryItems
        default:
            fatalError("Unsupported method \(method)")
        }
        
        //urlRequestの作成
        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue
    
        
        return urlRequest
    }
    
    func response(from data: Data, urlResponse: HTTPURLResponse) throws -> Response{
        let decoder = JSONDecoder()
        
        //エラー時と成功時で条件分け
        if (200...300).contains(urlResponse.statusCode){
            return try decoder.decode(Response.self, from: data)
        }
        else{
            throw try decoder.decode(GitHubAPIError.self, from: data)
        }
    }
    
}

public enum HTTPMethod : String {
     case get = "GET"
     case post = "POST"
     case put = "PUT"
     case head = "HEAD"
     case delete = "DELETE"
     case patch = "PATCH"
     case trace = "TRACE"
     case options = "OPTIONS"
     case connect = "CONNECT"
 }

