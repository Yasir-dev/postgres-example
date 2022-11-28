#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit 0;
fi

if [[ ! $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_INFO_RESULT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' OR name = '$1'");
else
  ELEMENT_INFO_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1");
fi

if [[ -z $ELEMENT_INFO_RESULT ]]
then
  echo "I could not find that element in the database."
else
   echo "$ELEMENT_INFO_RESULT" | while read ATOMIC_ID BAR SYMBOL BAR NAME
   do
    PROPERTY_RESULT=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOMIC_ID");
    echo "$PROPERTY_RESULT" | while read ATOMIC_ID BAR ATOMIC_MASS BAR MP_C BAR BP_C BAR TYPE_ID
    do
      TYPE_RESULT=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID");
      echo "The element with atomic number $ATOMIC_ID is $NAME ($SYMBOL). It's a $(echo $TYPE_RESULT | sed -r 's/^ *| *$//g'), with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MP_C celsius and a boiling point of $BP_C celsius."
    done
   done
fi  
