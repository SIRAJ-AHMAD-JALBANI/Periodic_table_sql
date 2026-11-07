#!/bin/bash

if [[ -z "$1" ]]; then
  printf '%s\n' "Please provide an element as an argument."
  exit 0
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align"
ELEMENT=$($PSQL -v element="$1" <<'SQL'
SELECT elements.atomic_number, elements.name, elements.symbol, types.type,
     properties.atomic_mass, properties.melting_point_celsius,
     properties.boiling_point_celsius
FROM elements
JOIN properties USING(atomic_number)
JOIN types USING(type_id)
WHERE elements.atomic_number::text = :'element'
  OR elements.symbol = :'element'
  OR elements.name = :'element';
SQL
)

if [[ -z "$ELEMENT" ]]; then
  printf '%s\n' "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r atomic_number name symbol type mass melting_point boiling_point <<< "$ELEMENT"
printf "The element with atomic number %s is %s (%s). It's a %s, with a mass of %s amu. %s has a melting point of %s celsius and a boiling point of %s celsius.\n" \
  "$atomic_number" "$name" "$symbol" "$type" "$mass" "$name" "$melting_point" "$boiling_point"
