//
//  DependencyInjectionBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 7/13/24.
//

import SwiftUI
import Combine

// PROBLEMS WITH SINGLETONS
// 1. Singgleton's are GLOBAL
// 2. Can't customize  the init!
// 3. Can't swap out dependencies

struct PostsModel: Identifiable, Codable {
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
}

protocol DataServiceProtocol {
    func getData() -> AnyPublisher<[PostsModel], Error>
}

class ProductionDataService: DataServiceProtocol {
    
//    static let instance = ProductionDataService() // Singleton
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getData() -> AnyPublisher<[PostsModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: [PostsModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

class MockDataService: DataServiceProtocol {
    
    let testData: [PostsModel]
    
    init(data: [PostsModel]?) {
        self.testData = data ?? [
        PostsModel(userId: 1, id: 1, title: "One", body: "one"),
        PostsModel(userId: 2, id: 2, title: "Two", body: "two")
        ]
    }
    
    func getData() -> AnyPublisher<[PostsModel], Error> {
        Just(testData)
            .tryMap({ $0 })
            .eraseToAnyPublisher()
    }
}


class DependencyInjectionViewModel: ObservableObject {
    
    @Published var dataArray: [PostsModel] = []
    var cancellables = Set<AnyCancellable>()
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) { // - fix first problem
        self.dataService = dataService
        loadPosts()
    }
    
    private func loadPosts() {
            dataService.getData()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedPosts in
                self?.dataArray = returnedPosts
            }
            .store(in: &cancellables)
    }
    
}

struct DependencyInjectionBootcamp: View {
    
    @StateObject private var vm: DependencyInjectionViewModel
    
    init(dataService: DataServiceProtocol) {
        _vm = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray) { post in
                    Text(post.title)
                }
            }
        }
    }
}

struct DependencyInjectionBootcamp_Previews: PreviewProvider {
    
//    static let dataService = ProductionDataService(url: URL(string:"https://jsonplaceholder.typicode.com/posts")!) // - fix second problem
    
    static let dataService = MockDataService(data: [
        PostsModel(userId: 3, id: 3, title: "Test", body: "test")
    ])
    
    static var previews: some View {
        DependencyInjectionBootcamp(dataService: dataService)
    }
}
