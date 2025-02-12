//
//  FuturesBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 2/12/25.
//

import SwiftUI
import Combine

// download with Combine
// download with @escaping closure
// convert @escaping closure to Combine

class FuturesBootcampViewModel: ObservableObject {
    
    @Published var title: String = "Starting title"
    let url = URL(string: "https://www.google.com")!
    var cancellables = Set<AnyCancellable>()
    
    init() {
        download()
    }
    
    func download() {
//        getCombinePublisher()
        
        getFuturePublisher()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
            .store(in: &cancellables)
        
//        getEscapingClosure { [weak self] returnedValue, error in
//            self?.title = returnedValue
//        }

    }
    
    func getCombinePublisher() -> AnyPublisher<String, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({ _ in
                return "New value"
            })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHalder: @escaping (_ value: String, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHalder("New value2", nil)
        }
        .resume()
    }
    
    func getFuturePublisher() -> Future<String, Error> {
        return Future { promise in
            self.getEscapingClosure { returnedValue, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(returnedValue))
                }
            }
        }
        
    }
    
    func doSomething(completionHalder: @escaping (_ value: String) -> ()){
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            completionHalder("NEW STRING")
        })
    }
    
    func doSomethingInTheFuture() -> Future<String, Never> {
        Future { promise in
            self.doSomething { value in
                promise(.success(value))
            }
        }
    }
    
}

struct FuturesBootcamp: View {
    
    @StateObject private var vm = FuturesBootcampViewModel()
    
    var body: some View {
        Text(vm.title)
    }
}

#Preview {
    FuturesBootcamp()
}
