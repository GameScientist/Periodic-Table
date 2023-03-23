#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [[ -z $1 ]] 
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^-?[0-9]+$ ]]
  then
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number='$1'")
  else
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements WHERE symbol='$1' OR name='$1'")
  fi
  echo $ELEMENT_RESULT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
  do
    if [[ -z $ELEMENT_RESULT ]] 
    then
      echo "I could not find that element in the database."
    else
      echo $($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number='$ATOMIC_NUMBER'") | while IFS="|" read MASS MELT BOIL TYPE_ID
      do
        TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID") 
        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
  done
fi
