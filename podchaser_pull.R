# =============================================================================
# podchaser_pull.R
# Artometrics — The Artometrics of H3
# Pull episode metadata + listener reviews from Podchaser API
# Run this script ONCE manually from the console. Never source from h3.qmd.
# Outputs: h3_podchaser_episodes.csv, h3_podchaser_reviews.csv
# =============================================================================

library(httr2)
library(jsonlite)
library(dplyr)
library(readr)
library(dotenv)

# -----------------------------------------------------------------------------
# 0. LOAD TOKEN
# -----------------------------------------------------------------------------
# Reads PODCHASER_TOKEN from your local .env file
dotenv::load_dot_env(".env")
token <- Sys.getenv("PODCHASER_TOKEN")

if (token == "" || token == "PASTE_YOUR_DEVELOPMENT_TOKEN_HERE") {
  stop("Token not found. Open .env and paste your Development Client Token.")
}

ENDPOINT <- "https://api.podchaser.com/graphql"

# Helper: send a GraphQL query and return parsed JSON
gql_post <- function(query, variables = list()) {
  resp <- request(ENDPOINT) |>
    req_headers(
      "Authorization" = paste("Bearer", token),
      "Content-Type"  = "application/json"
    ) |>
    req_body_json(list(query = query, variables = variables)) |>
    req_perform()
  
  resp |> resp_body_json(simplifyVector = TRUE)
}

# -----------------------------------------------------------------------------
# 1. FIND THE H3 PODCAST ID
# -----------------------------------------------------------------------------
cat("Step 1: Searching for H3 Podcast...\n")

search_query <- '
{
  podcasts(searchTerm: "H3 Podcast", first: 5) {
    data {
      id
      title
      author
      totalEpisodesCount
      averageRating
      ratingCount
    }
  }
}
'

search_result <- gql_post(search_query)
podcasts_found <- search_result$data$podcasts$data
print(podcasts_found[, c("id", "title", "author", "totalEpisodesCount")])

# Inspect the printed list and confirm the correct podcast ID
# The H3 Podcast main feed should be obvious from title + episode count
# Set the ID manually below after reviewing:
PODCAST_ID <- podcasts_found$id[1]  # Change index if not the first result
cat("Using Podcast ID:", PODCAST_ID, "\n")

# -----------------------------------------------------------------------------
# 2. PULL ALL EPISODES (paginated)
# -----------------------------------------------------------------------------
cat("Step 2: Pulling episode list...\n")

episode_query <- '
query GetEpisodes($id: ID!, $page: Int!) {
  podcast(identifier: { id: $id, type: PODCHASER }) {
    episodes(first: 100, page: $page, sort: [{ field: AIR_DATE, direction: ASC }]) {
      paginatorInfo {
        total
        lastPage
        currentPage
      }
      data {
        id
        title
        airDate
        length
        seasonNumber
        episodeNumber
      }
    }
  }
}
'

all_episodes <- list()
page <- 1
last_page <- 1

repeat {
  cat("  Fetching episodes page", page, "of", last_page, "...\n")
  result <- gql_post(episode_query, variables = list(id = PODCAST_ID, page = page))
  ep_data <- result$data$podcast$episodes
  
  last_page <- ep_data$paginatorInfo$lastPage
  all_episodes[[page]] <- ep_data$data
  
  if (page >= last_page) break
  page <- page + 1
  Sys.sleep(0.5)  # be polite to the API
}

episodes_df <- bind_rows(all_episodes) |>
  mutate(
    airDate       = as.Date(airDate),
    length_min    = round(length / 60, 1),
    episodeNumber = as.integer(episodeNumber),
    seasonNumber  = as.integer(seasonNumber)
  ) |>
  rename(
    episode_id     = id,
    episode_title  = title,
    air_date       = airDate,
    length_seconds = length,
    season         = seasonNumber,
    episode_num    = episodeNumber
  ) |>
  arrange(air_date)

cat("  Total episodes pulled:", nrow(episodes_df), "\n")

# -----------------------------------------------------------------------------
# 3. PULL ALL REVIEWS (paginated)
# -----------------------------------------------------------------------------
cat("Step 3: Pulling listener reviews...\n")

review_query <- '
query GetReviews($id: ID!, $page: Int!) {
  podcast(identifier: { id: $id, type: PODCHASER }) {
    reviews(first: 100, page: $page) {
      paginatorInfo {
        total
        lastPage
        currentPage
      }
      data {
        id
        rating
        created_at
        text
      }
    }
  }
}
'

all_reviews <- list()
page <- 1
last_page <- 1

repeat {
  cat("  Fetching reviews page", page, "of", last_page, "...\n")
  result <- gql_post(review_query, variables = list(id = PODCAST_ID, page = page))
  rv_data <- result$data$podcast$reviews
  
  last_page <- rv_data$paginatorInfo$lastPage
  all_reviews[[page]] <- rv_data$data
  
  if (page >= last_page) break
  page <- page + 1
  Sys.sleep(0.5)
}

reviews_df <- bind_rows(all_reviews) |>
  mutate(
    created_at = as.Date(created_at),
    rating     = as.numeric(rating)
  ) |>
  rename(review_id = id) |>
  arrange(created_at)

cat("  Total reviews pulled:", nrow(reviews_df), "\n")

# -----------------------------------------------------------------------------
# 4. WRITE TO CSV
# -----------------------------------------------------------------------------
cat("Step 4: Writing CSVs...\n")

write_csv(episodes_df, "h3_podchaser_episodes.csv")
write_csv(reviews_df,  "h3_podchaser_reviews.csv")

cat("\n Done.\n")
cat("  h3_podchaser_episodes.csv —", nrow(episodes_df), "rows\n")
cat("  h3_podchaser_reviews.csv  —", nrow(reviews_df),  "rows\n")
cat("\nNext: open these in RStudio, check the data, then decide which chart to build.\n")
