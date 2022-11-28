#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit 0;
fi

ATOMIC_ID_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1");


if [[ -z $ATOMIC_ID_RESULT ]]
then
  ATOMIC_SYMBOL_RESULT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1'");
  if [[ -z $ATOMIC_SYMBOL_ID_RESULT ]]
  then
    ATOMIC_NAME_RESULT=$($PSQL "SELECT * FROM elements WHERE name = '$1'");
    if [[ -z $ATOMIC_NUMBER_RESULT ]]
    then
    echo "I could not find that element in the database."
    fi
  fi
else
   echo "found"
fi
