#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if argument is empty
if [[ -z "$1" ]]
then 
  # send message that no argument as been given
  echo "Please provide an element as an argument."
else
  # check if argument is a number
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    # get element info as a number
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $1")
  else
   # get element info as symbol or name
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol = '$1' OR name = '$1'")
  fi
  # check if it exists
  if [[ -z $ELEMENT_INFO ]]
  then
    # send message that element isn't in the database
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT_INFO" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      # print message about the element
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
