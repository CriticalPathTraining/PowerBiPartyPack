library(XML)
library(dplyr)

getNFLTeam <- function(name, url, conference, division, city){
  tables <- readHTMLTable(url)
  for(i in 1:length(tables)){
    if(length(names(tables[[i]]))==8){
      dataframe <- tables[[i]]
      names(dataframe) <- c( "Number", "Name", "PositionCode", "Height", "Weight", "Age", "Experience", "College" )
      dataframe$Team = name
      dataframe$Conference = conference
      dataframe$Division = division
      dataframe$City = city
      return(dataframe)
      break
    }
  }
}

urlTeams <- "https://github.com/CriticalPathTraining/PowerBiPartyPack/raw/master/NFL/NFL%20Teams.csv"
teams <- read.csv(urlTeams, stringsAsFactors = FALSE)

players <- data.frame("Number"=character(0), 
                      "Name"=character(0), 
                      "PositionCode"=character(0), 
                      "Height"=integer(0), 
                      "Weight"=integer(0), 
                      "Age"=integer(0), 
                      "Experience"=character(0), 
                      "College"=character(0), 
                      "Team"=character(0),
                      "Conference"=character(0),
                      "Division"=character(0),
                      "City"=character(0))

by(teams, 1:nrow(teams), 
   function(team) {
     print(team$Team)
     teamRoster = getNFLTeam(team$Team, team$RosterUrl, team$Conference, team$Division, team$City )
     players <<- rbind(teamRoster, players)
   })

remove(teams)

write.csv(players, "NFL_Players.csv", row.names=FALSE)

