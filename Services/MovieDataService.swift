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

enum MovieServiceError: Error {
    case failedToGetResponse
    case failedToGetData
    case failedToDecodeData
    case errorOccurred
}

class MovieDataService: MovieDataServiceProtocol {
    func getPlayingNowMoviesList(completion: @escaping (Result<[Movie], MovieServiceError>)-> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=b2b14caf40262a9c19a366b15e4e3537&language=en-US&page=1") else { return }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
//                How can I use error.localizedDescription to display the error in the VC?
                completion(.failure(.errorOccurred))
                return
            }
            
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let moviesData = try? jsonDecoder.decode(Movies.self, from: data) else {
                completion(.failure(.failedToDecodeData))
                return
            }
            completion(.success(moviesData.results))
        }.resume()
    }
    
    func getMostPopularMoviesList(completion: @escaping (Result<[Movie], MovieServiceError>)-> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=94806a6f0ae52fc236885e625fc54d47&language=en-US&page=1") else { return }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.errorOccurred))
                return
            }
            
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let moviesData = try? jsonDecoder.decode(Movies.self, from: data) else {
                completion(.failure(.failedToDecodeData))
                return
            }
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
                completion(.failure(.failedToGetResponse))
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            guard let movieDetails = try? jsonDecoder.decode(MovieDetails.self, from: data) else {
                completion(.failure(.failedToGetResponse))
                return
            }
            completion(.success(movieDetails))
        }.resume()
    }
    
}


