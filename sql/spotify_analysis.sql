-- Row count
SELECT COUNT(*) FROM spotify_clean;
-- 950 rows/songs


-- Top 10 songs
SELECT
track_name,
artist_name,
streams
FROM spotify_clean
ORDER BY streams DESC
LIMIT 10;
-- Which songs had the most streams?
-- Of the top 10 songs, 5 were collaborations between more than one artist.
-- Only two songs accumulated over 3 billion streams: Blinding Lights by The Weeknd and Shape of You by Ed Sheeran.
-- All of the top 10 songs had over 2.5 billion streams.


-- Top 10 artists
SELECT
artist_name,
COUNT(*) AS num_songs
FROM spotify_clean
GROUP BY artist_name
ORDER BY num_songs DESC
LIMIT 10;
-- Which artists had the most top songs?
-- Taylor Swift dominated the top songs of 2023, with 34 songs. The next top artist was The Weeknd with 21 songs, which is only ~62% of Taylor Swift's songs.
-- There are only 7 artists with over 10 songs: Taylor Swift (34), The Weeknd (21), SZA (19), Bad Bunny (19), Harry Styles (17), Kendrick Lamar (12), and Morgan Wallen (11).
-- There seems to be a large range of genres from the top 10 artists: pop, R&B, rap, Latin trap, country, and hip-hop. 


-- Playlist impact
SELECT
track_name,
streams,
in_spotify_playlists,
released_year
FROM spotify_clean
ORDER BY in_spotify_playlists DESC
LIMIT 10;
-- Are the top 10 songs by streams also the songs in the most playlists?
-- Of the 10 songs in the most Spotify playlists, only one was also a top 10 hit: Blinding Lights by The Weeknd.
-- The vast majority of these songs are older, with 4 released before 2000 and none released 2020 or after.

SELECT
CASE
WHEN in_spotify_playlists >= 1000 THEN 'High Playlist Exposure'
ELSE 'Low Playlist Exposure'
END AS playlist_group,
AVG(streams) AS avg_streams
FROM spotify_clean
GROUP BY playlist_group;
-- Do songs in playlists get more streams?
-- Songs with high playlist exposure (songs in 1000 or more playlists on Spotify) have almost 6x the streams as songs with low playlist exposure.


-- Artist collaborations
SELECT
artist_count,
AVG(streams) as avg_streams
FROM spotify_clean
GROUP BY artist_count
ORDER BY avg_streams DESC;
-- Do songs with more artists perform better?
-- The order of most average streams follows very closely with the count of artists (1 artist: most average streams, 2 artists: second most average streams, etc.)
-- Interestingly, songs with 7 artists got the fourth most average streams, while songs with 6 artists got the least amount of average streams.


-- Audio features across all songs
SELECT
AVG(danceability_percent) AS avg_danceability,
AVG(energy_percent) AS avg_energy,
AVG(valence_percent) AS avg_valence
FROM spotify_clean;

-- Audio features of high/low playlist exposure songs
SELECT
CASE
WHEN in_spotify_playlists >= 1000 THEN 'High Playlist Exposure'
ELSE 'Low Playlist Exposure'
END AS playlist_group,
ROUND(AVG(danceability_percent),2) AS avg_danceability,
ROUND(AVG(energy_percent),2) AS avg_energy,
ROUND(AVG(valence_percent),2) AS avg_valence,
ROUND(AVG(acousticness_percent),2) AS avg_acousticness
FROM spotify_clean
GROUP BY playlist_group;
-- Do songs with high playlist exposure share similar audio characteristics?
-- Against what I would have hypothesized, songs with low playlist exposure have higher average danceability, average energy, average valence, and average acousticness.
-- This could be because there is a smaller amount of songs in the high playlist exposure category, which means every song has a higher impact on the average than the songs in the low playlist exposure group do.


-- Release year analysis
SELECT
released_year,
COUNT(*) AS song_count,
ROUND(AVG(streams),0) AS avg_streams
FROM spotify_clean
GROUP BY released_year
ORDER BY released_year;
-- Are older songs accumulating more streams because they've been on Spotify longer?
-- The top three years for most average streams in 2023 are (in order): 2022, 2023, and 2021. 
-- This means the most streams actually come from newer songs, not older songs.