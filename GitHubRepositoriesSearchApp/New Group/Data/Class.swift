//
//  Class.swift
//  GitHubSearchApp
//
//  Created by 金山義成 on 2024/02/01.
//

import SwiftUI

class GitHubAPI{
    //レポジトリーの検索
    struct SearchRepositories: GitHubRequest{
        let keyword: String
        
        
        typealias Response = SearchResponse<Repository>
        
        var method: HTTPMethod{
            return .get
        }
        
        var path: String{
            return "/search/repositories"
        }
        
        var queryItems: [URLQueryItem]{
            return [URLQueryItem(name: "q", value: keyword)]
        }
    }
    
    //ユーザーの検索
    struct SearchUsers: GitHubRequest {
         let keyword: String

         typealias Response = SearchResponse<User>

         var method: HTTPMethod {
             return .get
         }

         var path: String {
             return "/search/users"
         }

         var queryItems: [URLQueryItem] {
             return [URLQueryItem(name: "q", value: keyword)]
         }
     }
    
}

class SystemData:ObservableObject{
    //スマホサイズ
    @Published var widthOfPhone = UIScreen.main.bounds.width
    @Published var heightOfPhone = UIScreen.main.bounds.height
    
    
}

