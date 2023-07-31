#!/bin/bash -e
# Case statement in shellscript.
read -p "Enter expression to perform: " EXPER
case "${EXPER}" in
    "add")
        echo "This is addition section."
    ;;
    "sub")
        echo "This is substraction section."
    ;;
    "mul")
        echo "This is multiplication section."
    ;;
    "dev")
        echo "This is devide section."
    ;;
    *)
        echo "Select any - add, sub, mul, dev"
    ;;
esac