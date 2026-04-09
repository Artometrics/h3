# The Artometrics of H3

**By Artometrics | Where art meets industry**
[artometrics.com/h3](https://artometrics.com/h3) · [github.com/Artometrics/h3](https://github.com/Artometrics/h3)

A data-driven analysis of H3H3Productions — one of YouTube's most culturally significant creators — across views, eras, search behavior, Wikipedia footprint, and episode output.

---

## Datasets

| File | Source | Description |
|------|--------|-------------|
| `h3_master.csv` | YouTube Data API v3 | 1,638 videos across 4 H3 channels (filtered from 1,876 raw) |
| `h3_trends.csv` | Google Trends | Weekly search interest for 4 keywords, 2012–2026 |
| `h3_wikipedia.csv` | Wikimedia Pageviews API | Monthly Wikipedia pageviews for 4 articles, 2016–2026 |
| `h3_podchaser_episodes.csv` | Podchaser API | 680 unique H3 Podcast episodes with air dates and durations, 2017–2026 |

---

## Charts

| Chart | File | Description |
|-------|------|-------------|
| 1 | `chart1_era_timeline.png` | Monthly H3 Podcast views with era annotations |
| 2 | `chart2_channel_portfolio.png` | Per-video view distribution across all 4 channels |
| 3 | `chart3_era_breakdown.png` | H3 Podcast views per episode by era |
| 4 | `chart4_search_story.png` | Google Trends multi-line, 4 keywords |
| 5 | `chart5_wikipedia.png` | Wikipedia pageviews multi-line, 4 articles |

---

## Reproducing the Analysis

### Requirements

- R 4.1+
- Quarto
- R packages: `tidyverse`, `ggplot2`, `ggrepel`, `ggtext`, `lubridate`, `scales`, `here`, `httr2`, `dotenv`

Install all packages:

```r
install.packages(c(
  "tidyverse", "ggplot2", "ggrepel", "ggtext",
  "lubridate", "scales", "here", "httr2", "dotenv"
))
```

### Render the report

```r
quarto::quarto_render("h3.qmd")
```

### Re-pulling the Podchaser data

The Podchaser episode data is included as a static CSV. If you want to re-pull it fresh:

1. Copy `.env.example` to `.env`
2. Register at [podchaser.com/profile/settings/api](https://www.podchaser.com/profile/settings/api) and generate a free token
3. Paste your Development Client Token into `.env`
4. Run `podchaser_pull.R` from your console with the `/h3` folder as your working directory:

```r
setwd("path/to/h3")
source("podchaser_pull.R")
```

> ⚠️ Never commit your `.env` file. It is listed in `.gitignore`.

---

## Tools

- **R 4.5.1** — data cleaning, analysis, visualization
- **ggplot2** — all charts
- **Quarto** — report rendering
- **YouTube Data API v3** — video metadata
- **Google Trends** — search interest data
- **Wikimedia Pageviews API** — Wikipedia traffic
- **Podchaser API** — podcast episode metadata

---

## About Artometrics

Artometrics is a data journalism brand at the intersection of art, culture, and industry economics.

[artometrics.com](https://artometrics.com) · [GitHub](https://github.com/Artometrics) · [LinkedIn](https://linkedin.com/company/artometrics)

*Analysis by KSM. AI disclosure: portions of this workflow used Claude (Anthropic) for code assistance.*