PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
GET_DATA () {
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
  GET_INFO=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties 
  USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1;")
  PRINT_DATA $GET_INFO
elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
then
  GET_INFO=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties 
  USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1';")
  PRINT_DATA $GET_INFO
elif [[ $1 =~ ^[a-zA-Z]+$ ]]
then
  GET_INFO=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties 
  USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1';")
  PRINT_DATA $GET_INFO
fi
}

PRINT_DATA () {
#analyzing data
if [[ -z $1 ]] 
then
  NOT_FOUND
else
  echo $1 | while IFS="|" read NUMBER SYMBOL NAME TYPE MASS MELTING BOILING
  do
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi
}

NOT_FOUND () {
echo "I could not find that element in the database."
}

GET_DATA $1