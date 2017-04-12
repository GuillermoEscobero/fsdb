-- a) Predict-TVseries: next episode that is expected to be seen by each client
-- (the next to the last viewed; if it was the last of its season, it should be
-- taken the episode visualized immediately before in time (except from those
-- belonging to the ended season), and so on).
CREATE OR REPLACE VIEW predict_TVseries AS

-- b) predict-movie: next movie that is expected to be seen by each client. For
-- each client, each genre has a score equal to the number of films of the genre
-- watched by that client. The movie’s score is the sum of the scores of all
-- genres of the movie for that client. Note: in case you don’t have
-- individualized genres, you can write this query taking the first of each
-- sequence with: substr(genre,1,instr(genre,’|’)-1).
CREATE OR REPLACE VIEW predict_movie AS

-- c) hot-week: for each year, provide the 7-days period with higher traffic.
-- The periods can be whatever seven consecutive days (not necessarily natural
-- weeks). Periods between two years belong to the year with more days in it
-- (for example, from 28/12/2016 to 3/1/2017 belongs to 2016, while from
-- 29/12/2016 to 4/1/2017 belongs to 2017). For simplicity, you can consider
-- that all visualizations are performed completely within the day when they
-- begin.
CREATE OR REPLACE VIEW hot_week AS

-- d) Top-Content: For each month, display the content involving more income.
CREATE OR REPLACE VIEW top_content AS

-- e) Bacalá: top 5 movies dropped (stop viewing) after visualizing more than
-- half of its duration (viewing 97% or more is taken as complete visualization).
CREATE OR REPLACE VIEW bacala AS
SELECT * FROM
(
  SELECT TITLE
  FROM TAPS_MOVIES
  WHERE PCT BETWEEN 51 AND 96
  GROUP BY TITLE
  ORDER BY COUNT(TITLE) DESC
)
WHERE ROWNUM<=5;

-- f) Pigeonholed: stars with more than half of their movies (at least three) in
-- a given genre; in case of several matching genres, provide all/the most frequent
CREATE OR REPLACE VIEW pigeonholed AS
SELECT A.ACTOR, GENRE, A.top
FROM (
		SELECT MAX(counter) as top, ACTOR
		FROM (
			SELECT GENRE, ACTOR, COUNT(CASTS.TITLE) AS counter
			FROM CASTS
      JOIN GENRES_MOVIES ON CASTS.TITLE=GENRES_MOVIES.TITLE
			GROUP BY GENRE, ACTOR HAVING COUNT(CASTS.TITLE)>=3
		)
    GROUP BY ACTOR
) A
JOIN
(
	SELECT GENRE, ACTOR, COUNT(CASTS.TITLE) AS counter
	FROM CASTS
  JOIN GENRES_MOVIES ON CASTS.TITLE=GENRES_MOVIES.TITLE
  GROUP BY GENRE, ACTOR HAVING COUNT(CASTS.TITLE)>=3
) B
ON A.top=B.counter AND A.ACTOR=B.ACTOR
WHERE top>=(SELECT COUNT(CASTS.TITLE)/2 FROM CASTS GROUP BY ACTOR HAVING ACTOR=A.ACTOR)
ORDER BY TOP DESC;


-- g) All_movies: design a view with the same definition of the original old_movies.
-- Todo VARCHAR2(100) excepto PLOT_KEYWORDS que es VARCHAR2(150)
CREATE OR REPLACE VIEW all_movies AS
SELECT MOVIE_TITLE
FROM MOVIES
LEFT OUTER JOIN (SELECT TITLE, (LISTAGG(KEYWORD, '|') WITHIN GROUP (ORDER BY KEYWORD)) AS PLOT_KEYWORDS
      FROM KEYWORDS_MOVIES
      GROUP BY TITLE) A
      ON MOVIE_TITLE=A.TITLE
LEFT OUTER JOIN (SELECT TITLE, LISTAGG(GENRE, '|') WITHIN GROUP (ORDER BY GENRE) AS GENRES
      FROM GENRES_MOVIES
      GROUP BY TITLE) B
      ON MOVIE_TITLE=B.TITLE
      --Hay problemas para meter los actores en ACTOR_X_NAME y ACTOR_X_FACEBOOK_LIKES
LEFT OUTER JOIN (SELECT TITLE, ACTOR, FACEBOOK_LIKES
      FROM CASTS
      NATURAL JOIN PLAYERS) C
      ON MOVIE_TITLE=C.TITLE;
