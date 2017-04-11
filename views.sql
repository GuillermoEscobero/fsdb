-- a) Predict-TVseries: next episode that is expected to be seen by each client
-- (the next to the last viewed; if it was the last of its season, it should be
-- taken the episode visualized immediately before in time (except from those
-- belonging to the ended season), and so on).
CREATE VIEW predict_TVseries AS

-- b) predict-movie: next movie that is expected to be seen by each client. For
-- each client, each genre has a score equal to the number of films of the genre
-- watched by that client. The movie’s score is the sum of the scores of all
-- genres of the movie for that client. Note: in case you don’t have
-- individualized genres, you can write this query taking the first of each
-- sequence with: substr(genre,1,instr(genre,’|’)-1).
CREATE VIEW predict_movie AS

-- c) hot-week: for each year, provide the 7-days period with higher traffic.
-- The periods can be whatever seven consecutive days (not necessarily natural
-- weeks). Periods between two years belong to the year with more days in it
-- (for example, from 28/12/2016 to 3/1/2017 belongs to 2016, while from
-- 29/12/2016 to 4/1/2017 belongs to 2017). For simplicity, you can consider
-- that all visualizations are performed completely within the day when they
-- begin.
CREATE VIEW hot_week AS

-- d) Top-Content: For each month, display the content involving more income.
CREATE VIEW top_content AS

-- e) Bacalá: top 5 movies dropped (stop viewing) after visualizing more than
-- half of its duration (viewing 97% or more is taken as complete visualization).
CREATE VIEW bacala AS
SELECT * FROM
(
  SELECT TITLE
  FROM TAPS_MOVIES
  WHERE PCT BETWEEN 50 AND 97
  GROUP BY TITLE
  ORDER BY COUNT(TAPS_MOVIES.TITLE) DESC
)
WHERE ROWNUM<=5;

-- f) Pigeonholed: stars with more than half of their movies (at least three) in
-- a given genre; in case of several matching genres, provide all/the most frequent
CREATE VIEW pigeonholed AS
SELECT ACTOR, GENRE
FROM (
  SELECT MAX(film_number_genre) AS top
  FROM (
    SELECT ACTOR, GENRE, COUNT(MOVIE_TITLE) AS film_number_genre
    FROM MOVIES
    JOIN CASTS ON CASTS.TITLE=MOVIE_TITLE
    JOIN GENRES_MOVIES ON GENRES_MOVIES.TITLE=MOVIE_TITLE
    GROUP BY ACTOR, GENRE HAVING COUNT(MOVIE_TITLE)>=3
  )
)A JOIN (SELECT ACTOR, GENRE, COUNT(MOVIE_TITLE) AS film_number_genre
          FROM MOVIES
          JOIN CASTS ON CASTS.TITLE=MOVIE_TITLE
          JOIN GENRES_MOVIES ON GENRES_MOVIES.TITLE=MOVIE_TITLE
          GROUP BY ACTOR, GENRE HAVING COUNT(MOVIE_TITLE)>=3) B
ON A.top=B.film_number_genre







SELECT B.GENRE, ACTOR, A.top
FROM (
		SELECT MAX(counter) as top
		FROM (
			SELECT GENRE, ACTOR, COUNT(MOVIE_TITLE) AS counter
			FROM MOVIES
			JOIN CASTS ON MOVIES.MOVIE_TITLE=CASTS.TITLE
      JOIN GENRES_MOVIES ON MOVIES.MOVIE_TITLE=GENRES_MOVIES.TITLE
			GROUP BY GENRE, ACTOR
		)
) A
JOIN
(
	SELECT GENRE, ACTOR, COUNT(MOVIE_TITLE) AS counter
	FROM MOVIES
	JOIN CASTS ON MOVIES.MOVIE_TITLE=CASTS.TITLE
  JOIN GENRES_MOVIES ON MOVIES.MOVIE_TITLE=GENRES_MOVIES.TITLE
  GROUP BY GENRE, ACTOR
) B
ON A.top=B.counter
ORDER BY ACTOR


















-- g) All_movies: design a view with the same definition of the original old_movies.
-- Todo VARCHAR2(100) excepto PLOT_KEYWORDS que es VARCHAR2(150)
CREATE VIEW all_movies AS
SELECT COLOR, DIRECTOR_NAME, NUM_CRITIC_FOR_REVIEWS, DURATION, DIRECTOR_FACEBOOK_LIKES,
ACTOR_3_FACEBOOK_LIKES, ACTOR_2_FACEBOOK_LIKES, ACTOR_1_FACEBOOK_LIKES, GROSS, GENRES,
ACTOR_1_NAME, MOVIE_TITLE, NUM_VOTED_USERS, CAST_TOTAL_FACEBOOK_LIKES, ACTOR_3_NAME,
FACENUMBER_IN_POSTER, PLOT_KEYWORDS, MOVIE_IMDB_LINK, NUM_USER_FOR_REVIEWS,
FILMING_LANGUAGE, COUNTRY, CONTENT_RATING, BUDGET, ACTOR_2_FACEBOOK_LIKES, IMDB_SCORE,
ASPECT_RATIO, MOVIE_FACEBOOK_LIKES
FROM MOVIES
JOIN (SELECT TITLE, (LISTAGG(KEYWORD, '|') WITHIN GROUP (ORDER BY KEYWORD)) AS PLOT_KEYWORDS
      FROM KEYWORDS_MOVIES
      GROUP BY TITLE) A
      ON MOVIE_TITLE=A.TITLE
JOIN (SELECT TITLE, LISTAGG(GENRE, '|') WITHIN GROUP (ORDER BY GENRE) AS GENRES
      FROM GENRES_MOVIES
      GROUP BY TITLE) B
      ON MOVIE_TITLE=B.TITLE
      --Hay problemas para meter los actores en ACTOR_X_NAME y ACTOR_X_FACEBOOK_LIKES
JOIN (SELECT TITLE, ACTOR, ACTOR_FACEBOOK_LIKES
      FROM CASTS
      NATURAL JOIN PLAYERS)
