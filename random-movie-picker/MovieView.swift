//
//  MovieView.swift
//  random-movie-picker
//
//  Created by user217570 on 4/18/22.
//

import SwiftUI
import Alamofire
import SafariServices

struct Movie: Codable {
    var id: String
    var fullTitle: String
    var image: String
}

struct MovieList: Codable {
    var items: [Movie]
}

struct Trailer: Codable {
    var videoUrl: String
}

struct MovieView: View {
    let movieOrTv: String
    
    @State private var movieTitle = "Movie title"
    @State private var posterUrl = ""
    @State private var trailerUrl = "https://www.youtube.com/"
    var body: some View {
        VStack {
            Text(movieTitle).font(.headline).task {
                await getMovie()
            }
            AsyncImage(url: URL(string: posterUrl),
                                content: { image in
                                    image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 300, maxHeight: 600)
                                    },
                                placeholder:{
                                    ProgressView()
                                }
            )
            Link("Watch Trailer", destination: URL(string: trailerUrl)!)
            Spacer()
        }
    }
    
    func getMovie() async {
        let movieRequestUrl: String
        if (movieOrTv == "movie") {
            movieRequestUrl = "https://imdb-api.com/en/API/Top250Movies/k_s3vyrb4s"
        } else {
            movieRequestUrl = "https://imdb-api.com/en/API/Top250TVs/k_s3vyrb4s"
        }
        let movieRequest = AF.request(movieRequestUrl, method: .get)
        movieRequest.responseDecodable(of: MovieList.self) { response in
                    guard let moviesData = response.data else {
                      return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let movies = try decoder.decode(MovieList.self, from: moviesData)
                        let randomIndex = Int.random(in: 0..<250)
                        movieTitle = movies.items[randomIndex].fullTitle
                        posterUrl = movies.items[randomIndex].image
                        let movieId = movies.items[randomIndex].id
                        
                        let trailerRequestUrl = "https://imdb-api.com/en/API/YouTubeTrailer/k_s3vyrb4s/" + movieId
                        print(trailerRequestUrl)
                        
                        let trailerRequest = AF.request(trailerRequestUrl, method: .get)
                        trailerRequest.responseDecodable(of: Trailer.self) { trailerResponse in
                                    guard let trailerData = trailerResponse.data else {
                                      return
                                    }
                                    do {
                                        let decoder = JSONDecoder()
                                        let trailer = try decoder.decode(Trailer.self, from: trailerData)
                                        trailerUrl = trailer.videoUrl
                                    } catch {
                                        print("Error with decoding trailer request")
                                    }
                        }
                    } catch {
                        print("Error with decoding top 250 request")
                    }
                }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(movieOrTv: "movie")
    }
}
