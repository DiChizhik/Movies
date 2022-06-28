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
}

enum MovieServiceError: Error, LocalizedError {
    case failedToGetResponse
    case failedToGetData
    case failedToDecode
    
    var errorDescription: String? {
        switch self {
        case .failedToDecode:
            return "Failed to decode API response"
        case .failedToGetResponse:
            return "Failed to get API response"
        case .failedToGetData:
            return "Failed to load data"
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
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=b2b14caf40262a9c19a366b15e4e3537&language=en-US&page=\(playingNowPage)") else { return }
        
        isPlayingNowRequestCompleted = false
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.failedToGetResponse))
                return
            }
                   
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
             
            self.isPlayingNowRequestCompleted = true
            
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
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=94806a6f0ae52fc236885e625fc54d47&language=en-US&page=\(mostPopularPage)") else { return }

        isMostPopularRequestCompleted = false
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.failedToGetResponse))
                return
            }
                    
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
            
            self.isMostPopularRequestCompleted = true
            
            let jsonDecoder = JSONDecoder()
            guard let moviesData = try? jsonDecoder.decode(Movies.self, from: data) else {
                completion(.failure(.failedToDecode))
                return
            }
            
            self.mostPopularPage += 1
            completion(.success(moviesData.results))
        }.resume()
    }
    
    private func getMovieDetailsURL(movieId: Int) -> URL? {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=b2b14caf40262a9c19a366b15e4e3537&language=en-US") {
            return url
        }
        return nil
    }
    
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, MovieServiceError>)-> Void) {
        guard let url = getMovieDetailsURL(movieId: movieId) else { return }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
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
    
}


