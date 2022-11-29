#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

GREET() {
  echo -e "\n~~~~~ Number Guessing Game ~~~~~\n" 

  echo "Enter your username:"
  read NAME

  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$NAME'")

  if [[ -z $USER_ID ]]
  then
    
    echo -e "\nWelcome, $NAME! It looks like this is your first time here."

    INSERT_USER_RESULT=$($PSQL "INSERT INTO users(name) VALUES('$NAME')")

    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$NAME'")
    echo $USER_ID
  else
    GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id = '$USER_ID'")
    BEST_GUESS=$($PSQL "SELECT min(guesses) FROM games WHERE user_id = '$USER_ID'")

    echo -e "\nWelcome back, $NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GUESS guesses."  
  fi

  PLAY_GAME
}

PLAY_GAME() {

  NUMBER_TO_GUESS=$((1 + $RANDOM % 1000))
  ATTEMPS=0
  SUCCESS=0

  echo -e "\nGuess the secret number between 1 and 1000:"

  while [[ $SUCCESS = 0 ]]
  do
    read GUESS
    
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "\nThat is not an integer, guess again:"
    elif [[ $NUMBER_TO_GUESS = $GUESS ]]
    then
      ATTEMPS=$(($ATTEMPS + 1))
      echo -e "\nYou guessed it in $ATTEMPS tries. The secret number was $NUMBER_TO_GUESS. Nice job!"
      INSERTED_TO_GAMES=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $ATTEMPS)")
      SUCCESS=1
    elif [[ $NUMBER_TO_GUESS -gt $GUESS ]]
    then
      ATTEMPS=$(($ATTEMPS + 1))
      echo -e "\nIt's higher than that, guess again:"
    else
      ATTEMPS=$(($ATTEMPS + 1))
      echo -e "\nIt's lower than that, guess again:"
    fi
  done
}

GREET
