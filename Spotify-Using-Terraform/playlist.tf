resource "spotify_playlist" "playlist" {
  name        = "Cassette Classic"
  tracks = ["1kcV2LJxt5v0s2cEGtEJ5i", 
    "5oYRr51VatOtkFeEOursuZ", 
    "6ignzDlAQZe3ZLM8xZqjNK", 
    "6qNyL8lZuqFmy9ginJRQOZ", 
    "7IjnfuMNfdrAXbefurdIIR", 
    "0og9wKFGgFFNQnrBe7eisG"
    ]
}
resource "spotify_playlist" "Maroon_5" {
  name  = "Maroon 5 Playlist"

  tracks = flatten([
    data.spotify_search_track.Maroon_5.tracks[*].id,
  ])
}

data "spotify_search_track" "Maroon_5" {
  artist = "Maroon 5"
  limit  = 10
}