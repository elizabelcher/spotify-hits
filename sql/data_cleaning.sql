-- Determine any missing songs/streams
SELECT
SUM(CASE WHEN track_name IS NULL THEN 1 ELSE 0 END) AS missing_track,
SUM(CASE WHEN streams IS NULL THEN 1 ELSE 0 END) AS missing_streams
FROM spotify_songs;

-- Determine any duplicates
SELECT track_name,
"artist(s)_name",
COUNT(*) AS num_duplicates
FROM spotify_songs
GROUP BY track_name, "artist(s)_name"
HAVING COUNT(*) > 1;

-- Create new cleaned table with correct data types & no duplicates (only keeps the row with the highest streams of each duplicate pair)
CREATE TABLE spotify_clean AS
SELECT 
track_name,
"artist(s)_name" AS artist_name,
CAST(artist_count AS INTEGER) AS artist_count,
CAST(released_year AS INTEGER) AS released_year,
CAST(released_month AS INTEGER) AS released_month,
CAST(released_day AS INTEGER) AS released_day,
CAST(streams AS INTEGER) AS streams,
CAST(in_spotify_playlists AS INTEGER) AS in_spotify_playlists,
CAST(in_spotify_charts AS INTEGER) AS in_spotify_charts,
CAST(in_apple_playlists AS INTEGER) AS in_apple_playlists,
CAST(in_apple_charts AS INTEGER) AS in_apple_charts,
CAST(in_deezer_playlists AS INTEGER) AS in_deezer_playlists,
CAST(in_deezer_charts AS INTEGER) AS in_deezer_charts,
CAST(in_shazam_charts AS INTEGER) AS in_shazam_charts,
CAST(bpm AS INTEGER) AS bpm,
CAST("danceability_%" AS INTEGER) AS danceability_percent,
CAST("valence_%" AS INTEGER) AS valence_percent,
CAST("energy_%" AS INTEGER) AS energy_percent,
CAST("acousticness_%" AS INTEGER) AS acousticness_percent,
CAST("instrumentalness_%" AS INTEGER) AS instrumentalness_percent,
CAST("liveness_%" AS INTEGER) AS liveness_percent,
CAST("speechiness_%" AS INTEGER) AS speechiness_percent
FROM spotify_songs s1
WHERE streams =
(
    SELECT MAX(streams)
    FROM spotify_songs s2
    WHERE s1.track_name = s2.track_name
    AND s1."artist(s)_name" = s2."artist(s)_name"
);