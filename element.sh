#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then 
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number = '$1'")
  else
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol = '$1' or name = '$1'")
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then 
    echo "I could not find that element in the database."
  else
    NAME=$($PSQL "select name from elements where atomic_number = '$ATOMIC_NUMBER'")
    SYMBOL=$($PSQL "select symbol from elements where atomic_number = '$ATOMIC_NUMBER'")
    TYPE=$($PSQL "select type from types full join properties using(type_id) where atomic_number = '$ATOMIC_NUMBER'")
    MASS=$($PSQL "select atomic_mass from properties where atomic_number = '$ATOMIC_NUMBER'")
    MELTING=$($PSQL "select melting_point_celsius from properties where atomic_number = '$ATOMIC_NUMBER'")
    BOILING=$($PSQL "select boiling_point_celsius from properties where atomic_number = '$ATOMIC_NUMBER'")

    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."


  fi
fi