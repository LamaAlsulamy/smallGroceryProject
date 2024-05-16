#!/bin/bash

# display the list of products
display_products() {
    category="$1"
    products_file="$2"
    prices_file="$3"
    echo "List of $category:"
    paste -d '\t' "$products_file" "$prices_file" | nl
}
