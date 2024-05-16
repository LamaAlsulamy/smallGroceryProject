#!/bin/bash

# display the list of products
display_products() {
    category="$1"
    products_file="$2"
    prices_file="$3"
    echo "List of $category:"
    paste -d '\t' "$products_file" "$prices_file" | nl
}

# calculate the total cost
calculate_total() {
    total=0
    for price in "${selected_prices[@]}"; do
        price_value=$(echo "$price" | sed 's/SAR //')
        total=$(bc <<< "$total + $price_value")
    done
    echo "Total amount: SAR $total"
}
