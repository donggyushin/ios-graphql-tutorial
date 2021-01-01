//
//  NetworkInterceptorProvider.swift
//  IosGraphqlTutorial
//
//  Created by 신동규 on 2021/01/01.
//

import Foundation
import Apollo

class NetworkInterceptorProvider: LegacyInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(TokenAddingInterceptor(), at: 0)
        return interceptors
    }
}
