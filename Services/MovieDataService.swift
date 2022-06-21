//
//  MovieData.swift
//  Movies
//
//  Created by Diana Chizhik on 06/06/2022.
//

import Foundation
import UIKit

protocol MovieDataServiceProtocol {
    func getPlayingNowMoviesList(completion: @escaping ([Movie]?)-> Void)
    func getMostPopularMoviesList(completion: @escaping ([Movie]?)-> Void)
}

class MovieDataService: MovieDataServiceProtocol {
    func getPlayingNowMoviesList(completion: @escaping ([Movie]?)-> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=b2b14caf40262a9c19a366b15e4e3537&language=en-US&page=1") else { return }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let moviesData = try? jsonDecoder.decode(Movies.self, from: data) else {
                completion(nil)
                return
            }
            completion(moviesData.results)
        }.resume()
    }
    
    func getMostPopularMoviesList(completion: @escaping ([Movie]?)-> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=94806a6f0ae52fc236885e625fc54d47&language=en-US&page=1") else { return }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let moviesData = try? jsonDecoder.decode(Movies.self, from: data) else {
                completion(nil)
                return
            }
            completion(moviesData.results)
        }.resume()
    }
    
    private func getMovieDetailsURL(movieId: Int) -> URL? {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=b2b14caf40262a9c19a366b15e4e3537&language=en-US") {
            return url
        }
        return nil
    }
    
    func getMovieDetails(movieId: Int, completion: @escaping (MovieDetails?)-> Void) {
        guard let url = getMovieDetailsURL(movieId: movieId) else { return }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            guard let movieDetails = try? jsonDecoder.decode(MovieDetails.self, from: data) else {
                completion(nil)
                return
            }
            completion(movieDetails)
        }.resume()
    }
    
}

// ***Splitting into 2 methods

//class GetJSONService {
//    func getJSON(urlString: String) -> Data? {
//        guard let url = URL(string: urlString) else { return nil }
//        var json = Data()
//
//        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: request) {(data, response, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            guard let data = data else {
//                return
//            }
//            json = data
//        }.resume()
//        return json
//    }
//}
// class MovieDataService: {
//      let getJSONService = GetJSONService()
//
//    func getMoviesData(getJSONService: GetJSONService, urlString: String) -> [Movie]? {
//        if let moviesData = getJSONService.getJSON(urlString: urlString) {
//            let jsonDecoder = JSONDecoder()
//            if let moviesData = try? jsonDecoder.decode(Movies.self, from: moviesData) {
//                return moviesData.results
//            }
//        }
//       return nil
//    }
//}

// *** Implementation with JSONDecoder
//    func getMostPopularMoviesList(completion: @escaping ([Movie]?)-> Void) {
//        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=94806a6f0ae52fc236885e625fc54d47&language=en-US&page=1") else { return }
//
//        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: request) {(data, response, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(nil)
//                return
//            }
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//            let jsonDecoder = JSONDecoder()
//            guard let moviesData = try? jsonDecoder.decode(Movies.self, from: data) else {
//                completion(nil)
//                return
//            }
//            completion(moviesData.results)
//        }.resume()
//    }
//
//    private func getMovieDetailsURL(movieId: Int) -> URL? {
//        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=b2b14caf40262a9c19a366b15e4e3537&language=en-US") {
//            return url
//        }
//        return nil
//    }

// *** Generic function
//    func getData<T: Codable>(urlString: String, completion: @escaping (T?)-> Void) {
//        guard let url = URL(string: urlString) else { return }
//
//        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: request) {(data, response, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(nil)
//                return
//            }
//            guard let data = data else {
//                completion(nil)
//                return
//            }
//            let jsonDecoder = JSONDecoder()
//            guard let moviesData = try? jsonDecoder.decode(T.self, from: data) else {
//                completion(nil)
//                return
//            }
//            completion(moviesData)
//        }.resume()
//    }
