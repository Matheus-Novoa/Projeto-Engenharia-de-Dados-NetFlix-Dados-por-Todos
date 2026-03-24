-- ===================================================
-- MOVIES
-- ===================================================
CREATE OR REPLACE EXTERNAL TABLE `gen-lang-client-0712416565.netflix_raw.raw_movies`
(
  movieID STRING,
  title STRING,
  genres STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://pipeline-filmes-desafio/bronze/movies.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);

-- ===================================================
-- USER RATING HISTORY
-- ===================================================
CREATE OR REPLACE EXTERNAL TABLE `gen-lang-client-0712416565.netflix_raw.raw_user_rating_history`
(
  userId STRING,
  movieId STRING,
  rating STRING,
  tstamp STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://pipeline-filmes-desafio/bronze/user_rating_history.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);

-- ===================================================
-- BRIEF DATA
-- ===================================================
CREATE OR REPLACE EXTERNAL TABLE `gen-lang-client-0712416565.netflix_raw.raw_belief_data`
(
  userId STRING,
  movieId STRING,
  isSeen STRING,
  watchDate STRING,
  userElicitRating STRING,
  userPredictRating STRING,
  userCertainty STRING,
  tstamp STRING,
  month_idx STRING,
  source STRING,
  systemPredictRating STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://pipeline-filmes-desafio/bronze/belief_data.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);

-- ===================================================
-- MOVIE ELICITATION SET
-- ===================================================
CREATE OR REPLACE EXTERNAL TABLE `gen-lang-client-0712416565.netflix_raw.raw_movie_elicitation_set`
(
  movieId STRING,
  month_idx STRING,
  source STRING,
  tstamp STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://pipeline-filmes-desafio/bronze/movie_elicitation_set.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);

-- ===================================================
-- USER RECOMMENDATION HISTORY
-- ===================================================
CREATE OR REPLACE EXTERNAL TABLE `gen-lang-client-0712416565.netflix_raw.raw_user_recommendation_history`
(
  userId STRING,
  tstamp STRING,
  movieId STRING,
  predictedRating STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://pipeline-filmes-desafio/bronze/user_recommendation_history.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
);

-- ===================================================
-- RATINGS FOR ADDITIONAL USERS
-- ===================================================
CREATE OR REPLACE EXTERNAL TABLE `gen-lang-client-0712416565.netflix_raw.raw_ratings_for_additional_users`
(
  userId STRING,
  movieId STRING,
  rating STRING,
  tstamp STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://pipeline-filmes-desafio/bronze/ratings_for_additional_users.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  allow_jagged_rows = TRUE
)