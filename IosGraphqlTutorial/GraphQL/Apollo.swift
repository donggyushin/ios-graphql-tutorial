//
//  Apollo.swift
//  IosGraphqlTutorial
//
//  Created by 신동규 on 2021/01/01.
//

import Foundation
import Apollo





class Network {
    static let shared = Network()
        
    
    private(set) lazy var apollo: ApolloClient = {
            let client = URLSessionClient()
            let cache = InMemoryNormalizedCache()
            let store = ApolloStore(cache: cache)
            let provider = NetworkInterceptorProvider(client: client, store: store)
            let url = URL(string: "https://apollo-fullstack-tutorial.herokuapp.com/")!
            let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                         endpointURL: url)
            return ApolloClient(networkTransport: transport, store: store)
        }()
    
    func cancelTrip(launchId:GraphQLID, completion:@escaping((Error?, Bool?) -> Void)) {
        apollo.perform(mutation: CancleTripMutation(launchId: launchId)) { result in
            switch result {
            case .success(let graphQLResult):
                return completion(nil, graphQLResult.data?.cancelTrip.success)
            case .failure(let error):
                return completion(error, nil)
            }
        }
    }
    
    func bookTrips(launchIds:[GraphQLID], completion:@escaping((Error?, Bool?, String?) -> Void)) {
        apollo.perform(mutation: BookTripsMutation(launchIds: launchIds)) { result in
            switch result {
            case .success(let graphQLResult):
                completion(nil, graphQLResult.data?.bookTrips.success, graphQLResult.data?.bookTrips.message)
                break
            case .failure(let error):
                print(error.localizedDescription)
                completion(error, nil, nil)
                break
            }
        }
    }
    
    
    func login(completion:@escaping(String?) -> Void) {
    
        
        apollo.perform(mutation: LoginMutation(email: "donggyu9410@gmail.com")) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let graphQLResult):
                return completion(graphQLResult.data?.login)
            }
        }
        
        
    }
    
    
    func fetchLaunchDetail(id:GraphQLID, completion:@escaping((Error?, LaunchQuery.Data.Launch?) -> Void)) {
        apollo.fetch(query: LaunchQuery(id: id)) { result in
            switch result {
            case .success(let graphQLResult):
                return completion(nil, graphQLResult.data?.launch)
            case .failure(let error):
                return completion(error, nil)
            }
        }
    }
    
    func fetchMoreLaunches(cursor:String, completion:@escaping(Error?, [LaunchListQuery.Data.Launch.Launch]?, LaunchListQuery.Data.Launch?) -> Void) {
        apollo.fetch(query: LaunchListQuery(cursor: cursor)) { result in
            switch result {
            case .failure(let error):
                return completion(error, nil, nil)
            case .success(let graphQLResult):
                var launches = [LaunchListQuery.Data.Launch.Launch]()
                if let launcheConnection = graphQLResult.data?.launches {
                    launches.append(contentsOf: launcheConnection.launches.compactMap { $0 })
                }
                return completion(nil, launches, graphQLResult.data?.launches)
            }
        }
    }
    
    func fetchLuanchList(completion:@escaping(Error?, [LaunchListQuery.Data.Launch.Launch]?, LaunchListQuery.Data.Launch?) -> Void) {
        apollo.fetch(query: LaunchListQuery()) { result in
            switch result {
            case .failure(let error):
                return completion(error, nil, nil)
            case .success(let graphQLResult):
                var launches:[LaunchListQuery.Data.Launch.Launch] = []
                if let launchConnection = graphQLResult.data?.launches {
                    launches.append(contentsOf: launchConnection.launches.compactMap { $0 })
                }
                
                return completion(nil, launches, graphQLResult.data?.launches)
            }
        }
    }
    
}
