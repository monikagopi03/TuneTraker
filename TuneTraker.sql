Here is a single, complete SQL file for the "TuneTracker" project.

This file contains all the code required to:

Create the database schema (all the tables).

Populate the tables with sample data (artists, albums, tracks, users, and listening history).

Run complex analytical queries on the data to get business insights.

You can copy this entire block of code and run it in a SQL client (like PostgreSQL's psql, DBeaver, or an online SQL fiddle).

SQL

/*******************************************************************
*
* SQL PROJECT: "TuneTracker" Music Streaming Analytics
*
* DESCRIPTION: This script creates and populates a database for a
* music streaming service. It includes tables for artists, albums,
* tracks, users, and their play history. The end of the file
* contains several advanced analytical queries to demonstrate
* how to derive insights from this data.
*
*******************************************************************/


--=================================================================
-- SECTION 1: DDL (Data Definition Language)
-- Create the database structure (tables and relationships)
--=================================================================

-- Clean up tables if they already exist to make the script re-runnable
DROP TABLE IF EXISTS Play_History;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Tracks;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Artists;

-- Create Artists Table
CREATE TABLE Artists (
    artist_id INT PRIMARY KEY,
    artist_name VARCHAR(100) NOT NULL,
    genre VARCHAR(50)
);

-- Create Albums Table
CREATE TABLE Albums (
    album_id INT PRIMARY KEY,
    album_title VARCHAR(150) NOT NULL,
    artist_id INT,
    release_date DATE,
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id) ON DELETE CASCADE
);

-- Create Tracks Table
CREATE TABLE Tracks (
    track_id INT PRIMARY KEY,
    track_title VARCHAR(150) NOT NULL,
    album_id INT,
    duration_seconds INT,
    FOREIGN KEY (album_id) REFERENCES Albums(album_id) ON DELETE CASCADE
);

-- Create Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    join_date DATE,
    subscription_type VARCHAR(10) CHECK(subscription_type IN ('free', 'premium'))
);

-- Create Play_History Table (The "Fact" Table)
CREATE TABLE Play_History (
    play_id SERIAL PRIMARY KEY, -- Use SERIAL for auto-incrementing ID
    user_id INT,
    track_id INT,
    play_timestamp TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (track_id) REFERENCES Tracks(track_id) ON DELETE SET NULL
);

-- Add indexes for faster query performance on common JOIN/WHERE columns
CREATE INDEX idx_play_history_user_track ON Play_History(user_id, track_id);
CREATE INDEX idx_play_history_timestamp ON Play_History(play_timestamp);
CREATE INDEX idx_tracks_album ON Tracks(album_id);
CREATE INDEX idx_albums_artist ON Albums(artist_id);


--=================================================================
-- SECTION 2: DML (Data Manipulation Language)
-- Populate the tables with sample data
--=================================================================

-- Insert Artists
INSERT INTO Artists (artist_id, artist_name, genre) VALUES
(1, 'The Lumineers', 'Folk'),
(2, 'Daft Punk', 'Electronic'),
(3, 'Taylor Swift', 'Pop'),
(4, 'Kendrick Lamar', 'Hip Hop'),
(5, 'Miles Davis', 'Jazz');

-- Insert Albums
INSERT INTO Albums (album_id, album_title, artist_id, release_date) VALUES
(101, 'Cleopatra', 1, '2016-04-08'),
(102, 'Random Access Memories', 2, '2013-05-17'),
(103, '1989', 3, '2014-10-27'),
(104, 'To Pimp a Butterfly', 4, '2015-03-15'),
(105, 'Kind of Blue', 5, '1959-08-17'),
(106, 'Folklore', 3, '2020-07-24');

-- Insert Tracks
INSERT INTO Tracks (track_id, track_title, album_id, duration_seconds) VALUES
(1001, 'Ophelia', 101, 160),
(1002, 'Sleep on the Floor', 101, 211),
(1003, 'Angela', 101, 199),
(1004, 'Get Lucky', 102, 369),
(1005, 'Lose Yourself to Dance', 102, 353),
(1006, 'Blank Space', 103, 231),
(1007, 'Shake It Off', 103, 219),
(1008, 'King Kunta', 104, 234),
(1009, 'Alright', 104, 219),
(1010, 'So What', 105, 562),
(1011, 'Freddie Freeloader', 105, 589),
(1012, 'cardigan', 106, 239),
(1013, 'exile', 106, 285);

-- Insert Users
INSERT INTO Users (user_id, username, join_date, subscription_type) VALUES
(1, 'musiclover88', '2024-01-15', 'premium'),
(2, 'jazzfan_22', '2024-03-10', 'free'),
(3, 'pop_princess', '2024-05-01', 'premium'),
(4, 'hiphophead', '2024-07-20', 'free'),
(5, 'folkfanatic', '2024-02-20', 'premium');

-- Insert Play History
-- NOTE: Timestamps are 'YYYY-MM-DD HH:MI:SS'
-- We are using CURRENT_TIMESTAMP (assumed to be Nov 12, 2025)
-- to simulate recent data for Query 1.
INSERT INTO Play_History (user_id, track_id, play_timestamp) VALUES
-- User 1 (premium) - Listens to various genres
(1, 1001, '2025-11-01 08:15:00'), -- Ophelia (This month)
(1, 1004, '2025-11-01 08:18:00'), -- Get Lucky
(1, 1006, '2025-11-02 10:00:00'), -- Blank Space
(1, 1001, '2025-11-03 17:30:00'), -- Ophelia
(1, 1009, '2025-10-30 12:00:00'), -- Alright (Last month)

-- User 2 (free) - Jazz fan, creates sessions
(2, 1010, '2025-11-04 20:00:00'), -- So What (Session 1 Start)
(2, 1011, '2025-11-04 20:09:22'), -- Freddie Freeloader (Session 1 End)
(2, 1010, '2025-11-05 09:00:00'), -- So What (Session 2 Start)
(2, 1010, '2025-11-05 09:09:22'), -- So What
(2, 1011, '2025-11-05 09:18:44'), -- Freddie Freeloader (Session 2 End)
(2, 1010, '2025-11-05 14:00:00'), -- So What (Session 3 Start/End - 1 song)

-- User 3 (premium) - Taylor Swift super-fan
(3, 1006, '2025-11-01 07:05:00'), -- Blank Space (This month)
(3, 1007, '2025-11-01 07:09:00'), -- Shake It Off
(3, 1012, '2025-11-01 07:13:00'), -- cardigan
(3, 1013, '2025-11-02 11:15:00'), -- exile
(3, 1006, '2025-11-02 11:20:00'), -- Blank Space
(3, 1006, '2025-11-03 12:00:00'), -- Blank Space
(3, 1006, '2025-11-04 13:00:00'), -- Blank Space
(3, 1006, '2025-11-05 14:00:00'), -- Blank Space (Very popular)
(3, 1012, '2025-11-06 15:00:00'), -- cardigan
(3, 1007, '2025-10-28 10:00:00'), -- Shake It Off (Last month)

-- User 4 (free) - Hip Hop fan, short sessions
(4, 1008, '2025-11-07 18:00:00'), -- King Kunta (Session 1 Start)
(4, 1009, '2025-11-07 18:03:54'), -- Alright (Session 1 End)
(4, 1008, '2025-11-07 21:00:00'), -- King Kunta (Session 2 Start)
(4, 1009, '2025-11-07 21:03:54'), -- Alright (Session 2 End)
(4, 1008, '2025-10-15 17:00:00'), -- King Kunta (Last month)

-- User 5 (premium) - Folk fanatic
(5, 1001, '2025-11-01 09:00:00'), -- Ophelia (This month)
(5, 1002, '2025-11-01 09:02:40'), -- Sleep on the Floor
(5, 1003, '2025-11-01 09:06:11'), -- Angela
(5, 1001, '2025-11-03 10:00:00'), -- Ophelia
(5, 1002, '2025-11-05 11:00:00'), -- Sleep on the Floor
(5, 1001, '2025-11-07 12:00:00'); -- Ophelia


--=================================================================
-- SECTION 3: ANALYTICAL QUERIES
-- Run these queries to analyze the data.
--=================================================================

---
--- QUERY 1: Top 5 Most Popular Tracks This Month (with Artist/Album)
---
--- DESCRIPTION: A core business query to find what's trending.
--- It joins four tables, filters by the current month, aggregates
--- play counts, and presents a user-friendly report.
---
SELECT
    T.track_title AS "Track Title",
    A.artist_name AS "Artist",
    Al.album_title AS "Album",
    COUNT(PH.play_id) AS total_plays
FROM
    Play_History PH
JOIN
    Tracks T ON PH.track_id = T.track_id
JOIN
    Albums Al ON T.album_id = Al.album_id
JOIN
    Artists A ON Al.artist_id = A.artist_id
WHERE
    -- Use DATE_TRUNC (standard SQL/PostgreSQL) to get the first day of the current month.
    -- For MySQL, you might use:
    -- PH.play_timestamp >= DATE_FORMAT(CURRENT_DATE, '%Y-%m-01')
    PH.play_timestamp >= DATE_TRUNC('month', CURRENT_TIMESTAMP)
    AND PH.play_timestamp < DATE_TRUNC('month', CURRENT_TIMESTAMP) + INTERVAL '1 month'
GROUP BY
    T.track_id, T.track_title, A.artist_name, Al.album_title
ORDER BY
    total_plays DESC
LIMIT 5;


---
--- QUERY 2: User Listening Session Analysis (Advanced)
---
--- DESCRIPTION: This complex query defines a "session" as a series
--- of plays where the gap between songs is 30 minutes or less.
--- It uses Common Table Expressions (CTEs) and Window Functions
--- (LAG, SUM) to identify these sessions and calculate the
--- average session length for each user.
---
WITH Ranked_Plays AS (
    -- First, get each user's plays and the time of the *previous* play
    SELECT
        user_id,
        play_timestamp,
        -- Use LAG to find the previous play time *within each user's partition*
        LAG(play_timestamp, 1) OVER (
            PARTITION BY user_id
            ORDER BY play_timestamp
        ) AS previous_play_time
    FROM
        Play_History
),
Session_Identifier AS (
    -- Next, identify the start of a new session
    -- A new session starts if the previous play was NULL (first play)
    -- or if the gap is more than 30 minutes (1800 seconds)
    SELECT
        user_id,
        play_timestamp,
        CASE
            WHEN previous_play_time IS NULL THEN 1
            -- EXTRACT(EPOCH FROM ...) calculates total seconds between two timestamps
            WHEN EXTRACT(EPOCH FROM (play_timestamp - previous_play_time)) > 1800 THEN 1
            ELSE 0
        END AS is_session_start
    FROM
        Ranked_Plays
),
Session_Grouping AS (
    -- Now, create a unique session_id for each user's session
    -- This running total (SUM over a window) increments every time a new session starts
    SELECT
        user_id,
        play_timestamp,
        SUM(is_session_start) OVER (
            PARTITION BY user_id
            ORDER BY play_timestamp
        ) AS session_id
    FROM
        Session_Identifier
),
Session_Durations AS (
    -- Finally, calculate the duration of each session (max time - min time)
    SELECT
        user_id,
        session_id,
        -- Calculate duration; add 1 second for single-song sessions
        (MAX(play_timestamp) - MIN(play_timestamp)) + INTERVAL '1 second' AS session_duration
    FROM
        Session_Grouping
    GROUP BY
        user_id, session_id
)
-- The final query: get the average session duration for all users
SELECT
    U.username,
    -- TO_CHAR formats the interval nicely (e.g., 'HH24:MI:SS')
    -- AVG() computes the average of the session_duration intervals
    TO_CHAR(AVG(SD.session_duration), 'HH24:MI:SS') AS average_session_time
FROM
    Session_Durations SD
JOIN
    Users U ON SD.user_id = U.user_id
GROUP BY
    U.user_id, U.username
ORDER BY
    AVG(SD.session_duration) DESC;


---
--- QUERY 3: Artist Popularity Ranking by Subscription Type
---
--- DESCRIPTION: This query investigates whether "premium" and "free"
--- users have different listening habits. It uses a CTE to
--- aggregate play counts and then the RANK() window function to
--- create a separate leaderboard for each subscription type.
---
WITH Play_Counts_By_User_Type AS (
    -- First, count plays for each artist by each subscription type
    SELECT
        A.artist_name,
        U.subscription_type,
        COUNT(PH.play_id) AS total_plays
    FROM
        Play_History PH
    JOIN
        Users U ON PH.user_id = U.user_id
    JOIN
        Tracks T ON PH.track_id = T.track_id
    JOIN
        Albums Al ON T.album_id = Al.album_id
    JOIN
        Artists A ON Al.artist_id = A.artist_id
    GROUP BY
        A.artist_name, U.subscription_type
)
-- Now, rank the artists within each subscription_type group
SELECT
    subscription_type,
    artist_name,
    total_plays,
    -- The RANK() function assigns a rank, partitioning by subscription_type
    RANK() OVER (
        PARTITION BY subscription_type
        ORDER BY total_plays DESC
    ) AS popularity_rank
FROM
    Play_Counts_By_User_Type
ORDER BY
    subscription_type, popularity_rank;

/*******************************************************************
*
* END OF SCRIPT
*
*******************************************************************/