require(retrosheet)
require(dplyr)
require(stringr)

setwd("~/code/3_0_counts/")
year <- 2019

team_id <- read_csv("TEAMABR.csv", col_names = TRUE)
team_id <- dplyr::filter(team_id, end == 2010)
team_id <- dplyr::select(team_id, code)

for (j in 1:nrow(team_id)) {
  data <- retrosheet::get_retrosheet("play", year, team_id[[1]][j])
  file_name <- paste("raw_data/", year, "_", team_id[[1]][j], ".txt", sep = "")
  save(data, file=file_name)
  for (i in 1:length(data)) {
    plays <- data[[i]]$play
    pitches_30 <- dplyr::filter(plays, stringr::str_detect(plays$pitches, "^BBB"))
    pitches_30_agg <- rbind(pitches_30_agg, pitches_30)
  }
}

write_csv(pitches_30_agg, "clean_data/all_pitches.csv")
