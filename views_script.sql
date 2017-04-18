-------------------------------------------------------------------------------
-- views_script.sql
-- 		Guillermo Escobero (100346060)
-- 		Raul Olmedo Checa (100346073)
-------------------------------------------------------------------------------

-- e) Bacalá: top 5 movies dropped (stop viewing) after visualizing more than
-- half of its duration (viewing 97% or more is taken as complete visualization).
CREATE OR REPLACE VIEW bacala AS
SELECT * FROM
(
  SELECT title
  FROM taps_movies
  WHERE pct BETWEEN 51 AND 96
  GROUP BY title
  ORDER BY COUNT(title) DESC
)
WHERE ROWNUM<=5;

-- f) Pigeonholed: stars with more than half of their movies (at least three) in
-- a given genre; in case of several matching genres, provide all/the most frequent
CREATE OR REPLACE VIEW pigeonholed AS
SELECT A.actor, genre, top
FROM (
		SELECT MAX(counter) as top, actor
		FROM (
			SELECT genre, actor, COUNT(title) AS counter
			FROM casts
      NATURAL JOIN genres_movies
			GROUP BY genre, actor HAVING COUNT(title)>=3
		)
    GROUP BY actor
) A
JOIN
(
	SELECT genre, actor, COUNT(title) AS counter
  FROM casts
  NATURAL JOIN genres_movies
  GROUP BY genre, actor HAVING COUNT(title)>=3
) B
ON top=counter AND A.actor=B.actor
WHERE top>=(SELECT COUNT(title)/2 FROM casts GROUP BY actor HAVING actor=A.actor)
ORDER BY top DESC;


-- g) All_movies: design a view with the same definition of the original old_movies.
-- TODO: Todo VARCHAR2(100) excepto PLOT_KEYWORDS que es VARCHAR2(150)
-- TODO: Pasar de C Y BN a Color y whiteblack como en fsdb.old_movies
CREATE OR REPLACE VIEW all_movies AS
SELECT CASE WHEN color='B' THEN 'Black and White' WHEN color='C' THEN 'Color' ELSE null END,
director_name, num_critic_for_reviews, duration, director_facebook_likes,
gross, movie_title, num_voted_users, cast_total_facebook_likes,
facenumber_in_poster, movie_imdb_link, num_user_for_reviews,
filming_language, country, content_rating, budget, imdb_score, aspect_ratio, movie_facebook_likes ,plot_keywords,
genres, actor_1_name, actor_1_facebook_likes, actor_2_name, actor_2_facebook_likes, actor_3_name, actor_3_facebook_likes
FROM movies
LEFT OUTER JOIN (SELECT title, keyword AS plot_keywords FROM keywords_movies) A ON movie_title=A.title
LEFT OUTER JOIN (SELECT title, genre AS genres FROM genres_movies) B on movie_title=B.title
LEFT OUTER JOIN (SELECT title, actor_1_name, actor_1_facebook_likes, actor_2_name, actor_2_facebook_likes, actor_3_name, actor_3_facebook_likes
                 FROM (
                  (SELECT title, SUBSTR((LISTAGG(actor, '|') WITHIN GROUP (ORDER BY actor)), 1, INSTR((LISTAGG(actor, '|') WITHIN GROUP (ORDER BY actor)), '|')-1) AS actor_1_name,
                  SUBSTR((LISTAGG(actor, '|') WITHIN GROUP (ORDER BY actor)), INSTR((LISTAGG(actor, '|') WITHIN GROUP (ORDER BY actor)), '|')+1,
                  INSTR((LISTAGG(actor, '|') WITHIN GROUP (ORDER BY actor)), '|', 1, 2) - INSTR((LISTAGG(actor, '|') WITHIN GROUP (ORDER BY actor)), '|')-1) AS actor_2_name,
                  SUBSTR((LISTAGG(actor, '|') WITHIN GROUP (ORDER BY actor)), INSTR((LISTAGG(actor, '|') WITHIN GROUP (ORDER BY actor)), '|', -1, 1)+1) AS actor_3_name
                  FROM casts
                  GROUP BY title)
                  LEFT OUTER JOIN
                    (SELECT actor_name, facebook_likes AS actor_1_facebook_likes FROM players) D
                  ON actor_1_name=D.actor_name
                  LEFT OUTER JOIN
                    (SELECT actor_name, facebook_likes AS actor_2_facebook_likes FROM players) E
                  ON actor_2_name=E.actor_name
                  LEFT OUTER JOIN
                    (SELECT actor_name, facebook_likes AS actor_3_facebook_likes FROM players) F
                  ON actor_3_name=F.actor_name
                 )
               ) C ON movie_title=C.title;
