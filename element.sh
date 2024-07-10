#!/bin/bash

#add the PSQL token
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c" 

NOT_FOUND_MESSAGE="I could not find that element in the database."
LOOKUP_PROPERTIES() {
  # look up the info using the number 
  if [[ $2 == 'number' ]]
  then
    LOOKUP_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id)WHERE atomic_number = $1")
    if [[ -z $LOOKUP_RESULT ]]
    then
      echo $NOT_FOUND_MESSAGE
    else
      echo $LOOKUP_RESULT | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
      do 
        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  elif [[ $2 == 'symbol' ]]
  then
    LOOKUP_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id)WHERE symbol = '$1'")
    if [[ -z $LOOKUP_RESULT ]]
    then
      echo $NOT_FOUND_MESSAGE
    else
      echo $LOOKUP_RESULT | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
      do 
        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  elif [[ $2 == 'name' ]]
  then
    LOOKUP_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id)WHERE name = '$1'")
    if [[ -z $LOOKUP_RESULT ]]
    then
      echo $NOT_FOUND_MESSAGE
    else
      echo $LOOKUP_RESULT | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
      do 
        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  fi
  # if
  #echo $LOOKUP_RESULT 
}

if [[ -z $1 ]]
# If there is no argument
then 
  echo Please provide an element as an argument.
# If there is an argument
else
  # Check if the argument is an atomic number (technically, if it's just a number at all).
  if [[ $1 =~ ^[0-9]+$ ]]
  # If so, look up data using the atomic number
  then
    LOOKUP_PROPERTIES $1 number
  # If not, check if the argument is an atomic symbol
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then 
    LOOKUP_PROPERTIES $1 symbol
    
  # If not, check if the argument is a name
  elif [[ $1 =~ ^[A-Z][a-z]+$ ]]
  then
    LOOKUP_PROPERTIES $1 name
    
  else
    echo $NOT_FOUND_MESSAGE
  fi
fi
