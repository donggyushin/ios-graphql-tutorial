//
//  TokenAddingInterceptor.swift
//  IosGraphqlTutorial
//
//  Created by 신동규 on 2021/01/01.
//
import Foundation
import Apollo

class TokenAddingInterceptor: ApolloInterceptor {
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        
        // TODO
        if let token = LocalStorageService.shared.fetAuthToken() {
            request.addHeader(name: "Authorization", value: token)
        }
        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
}
