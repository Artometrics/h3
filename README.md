# H3: The Artometrics of a YouTube Dynasty

A creator profile data analysis of the H3 Podcast network — Ethan and Hila Klein's
four-channel operation — built on a custom dataset assembled via the
[YouTube Data API v3](https://developers.google.com/youtube/v3), Wikipedia Pageviews API,
and Google Trends.

## What's in this repo

- `h3.qmd` — Quarto markdown file containing all R, SQL, and Python code, analysis, and write-up
- `data/h3_master.csv` — master dataset: 1,638 videos across 4 channels (filtered)
- `data/h3_wikipedia.csv` — Wikipedia pageview data (monthly)
- `data/h3_wikipedia_daily.csv` — Wikipedia pageview data (daily)
- `data/h3_trends.csv` — Google Trends data via `gtrendsR`
- `data/h3_podchaser_episodes.csv` — episode-level podcast data from Podchaser
- `charts/chart1_era_timeline.png` — monthly H3 Podcast views 2017–2026 with Frenemies and Leftovers era markers
- `charts/chart2_duration_drift.png` — episode duration drift by era and channel
- `charts/chart3_reddit_activity.png` — Reddit activity: r/h3h3productions vs r/h3snark over time

## What the analysis covers

Three charts and a polyglot analysis (R + SQL + Python) working through
what the data actually shows about one of YouTube's most unusual long-run careers:

1. How H3 Podcast viewership evolved across four distinct eras — and what killed each one
2. Whether episodes are getting longer, shorter, or more erratic — and what that signals about format
3. How fan sentiment on Reddit splits between the main sub and the snark sub across the same events

## Read the full article

[artometrics.com/h3-the-artometrics-of-a-youtube-dynasty](https://www.artometrics.com/h3-the-artometrics-of-a-youtube-dynasty/)

## Data sources

- [YouTube Data API v3](https://developers.google.com/youtube/v3) — video metadata, view counts, upload dates (Google Cloud project: ARTOMETRICS)
- [Wikipedia Pageviews API](https://wikitech.wikimedia.org/wiki/Analytics/AQS/Pageviews) — no key required
- [Google Trends](https://trends.google.com) via `gtrendsR` R package
- [Podchaser](https://www.podchaser.com) — episode-level podcast metadata

**Note:** Reddit JSONL source files (r/h3h3productions, r/h3snark) exceed GitHub's
100 MB file size limit and are excluded from this repo. The processed summary CSV
is included at `data/h3_snark_posts.csv`.

## Tools

- R / Quarto
- tidyverse · ggplot2 · ggrepel · ggtext · scales · lubridate · httr · jsonlite · gtrendsR
- Python (pandas · numpy) · SQL

## Disclosure

This analysis is based on original data work (R / YouTube Data API v3). AI was
used to assist in analysis, research, and writing.
