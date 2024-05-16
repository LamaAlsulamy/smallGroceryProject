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

# Function to save and print purchase invoice
save_invoice() {
    invoice_file="$1"
    invoice_content="----- Invoice -----\n"
    invoice_content+="Date: $(date)\n"
    invoice_content+="Customer: $customer_name\n"
    invoice_content+="Delivery: $delivery_choice\n"
    for ((i=0; i<${#selected_products[@]}; i++)); do
        invoice_content+="${selected_products[$i]} - ${selected_prices[$i]}\n"
    done
    invoice_content+="Total amount: SAR $total_amount\n"
    invoice_content+="-------------------\n"

    # Print the content of the invoice
    echo -e "$invoice_content"

    # Save the invoice content to a separate file
    echo -e "$invoice_content" >>"$invoice_file"

}
