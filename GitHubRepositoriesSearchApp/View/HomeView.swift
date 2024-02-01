//
//  HomeView.swift
//  GitHubSearchApp
//
//  Created by 金山義成 on 2024/02/01.
//

import SwiftUI

struct HomeView: View {
    @State var searchWord: String = ""
    @State var getRepositories:SearchResponse<Repository>? = nil
    
    func searching(){
        //APIクライアントの生成
        let client = GitHubClient(httpClient: URLSession.shared)
        print("client:",client)
        //リクエストの発行
        let request = GitHubAPI.SearchRepositories(keyword: searchWord)
        print("request.path:",request.path)
        print("request.queryItems:",request.queryItems)
        
        //リクエストの送信
        client.send(request: request){result in
            switch result{
            case .success(let response):
                print("success")
                print(response)
                getRepositories = response
                
                
            case .failure(let error):
                print("failure")
                print(error)
            }
        }
        
    }
    
    
    var body: some View {
        VStack{
            TextField("検索ワードを入力", text: $searchWord, onCommit: {
                searching()
            })
            
            ScrollView{
                //getRepositoriesがnilでないことを確認
                if let repositories = getRepositories {
                    //repositoriesを使って何か処理をする
                    ForEach(repositories.items, id:\.self){ item in
                        Text(item.name)
                    }
                }
            }
        }.padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
