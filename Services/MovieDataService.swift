//
//  MovieData.swift
//  Movies
//
//  Created by Diana Chizhik on 06/06/2022.
//

import Foundation
import UIKit

protocol MovieDataServiceProtocol {
    func getPlayingNowMoviesList(completion: @escaping (Result<[Movie], MovieServiceError>)-> Void)
    func getMostPopularMoviesList(completion: @escaping (Result<[Movie], MovieServiceError>)-> Void)
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, MovieServiceError>)-> Void)
    func searchMovies(matching query: String, completion: @escaping (Result<[Movie], MovieServiceError>)-> Void)
}

protocol ErrorViewHandleable {
    var errorImage: UIImage? { get }
    var errorTitle: String { get }
}

enum MovieServiceError: Error, LocalizedError, ErrorViewHandleable {
    case failedToGetResponse
    case failedToGetData
    case failedToDecode
    
    var errorTitle: String {
        switch self {
        case .failedToDecode:
            return "Failed to decode data.\nCall the special agents."
        case .failedToGetResponse:
            return "Sherlock didn’t find the internet signal.\nPlease try again later."
        case .failedToGetData:
            return "Houston, we have a problem.\nClose and re-open the app."
        }
    }
    
    var errorImage: UIImage? {
        switch self {
        case .failedToGetData:
            return #imageLiteral(resourceName: "dizzy")
        case .failedToDecode:
            return #imageLiteral(resourceName: "spy")
        case .failedToGetResponse:
            return #imageLiteral(resourceName: "wifi")
        }
    }
}

class MovieDataService: MovieDataServiceProtocol {
    var playingNowPage = 1
    var mostPopularPage = 1
    var isPlayingNowRequestCompleted = true
    var isMostPopularRequestCompleted = true
    
    func getPlayingNowMoviesList(completion: @escaping (Result<[Movie], MovieServiceError>)-> Void) {
        guard isPlayingNowRequestCompleted else { return }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/movie/now_playing"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: MovieDataServiceInfo.key),
            URLQueryItem(name: "page", value: String(playingNowPage))
        ]
        guard let url = urlComponents.url else { return }
        
        isPlayingNowRequestCompleted = false
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            self.isPlayingNowRequestCompleted = true
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.failedToGetResponse))
                return
            }
                   
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let moviesData = try? jsonDecoder.decode(Movies.self, from: data) else {
                completion(.failure(.failedToDecode))
                return
                }
            
            self.playingNowPage += 1
            completion(.success(moviesData.results))
        }.resume()
    }
    
    func getMostPopularMoviesList(completion: @escaping (Result<[Movie], MovieServiceError>)-> Void) {
        guard isMostPopularRequestCompleted else { return }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/movie/popular"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: MovieDataServiceInfo.key),
            URLQueryItem(name: "page", value: String(mostPopularPage))
        ]
        guard let url = urlComponents.url else { return }

        isMostPopularRequestCompleted = false
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            self.isMostPopularRequestCompleted = true
            
            if let _ = error {
                completion(.failure(.failedToGetResponse))
                return
            }
                    
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let moviesData = try? jsonDecoder.decode(Movies.self, from: data) else {
                completion(.failure(.failedToDecode))
                return
            }
            
            self.mostPopularPage += 1
            completion(.success(moviesData.results))
        }.resume()
    }
    
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, MovieServiceError>)-> Void) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/movie/\(movieId)"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: MovieDataServiceInfo.key)
        ]
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let _ = error {
                completion(.failure(.failedToGetResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
            guard let movieDetails = try? jsonDecoder.decode(MovieDetails.self, from: data) else {
                completion(.failure(.failedToDecode))
                return
            }
            
            completion(.success(movieDetails))
        }.resume()
    }
    
    func searchMovies(matching query: String, completion: @escaping (Result<[Movie], MovieServiceError>)-> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/search/movie"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: MovieDataServiceInfo.key),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "1")
        ]
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(.failedToGetResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.failedToGetData))
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                guard let moviesData = try? jsonDecoder.decode(Movies.self, from: data) else {
                    completion(.failure(.failedToDecode))
                    return
                }
                
                completion(.success(moviesData.results))
            }.resume()
    }
}


