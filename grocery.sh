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

#---------------------------------------------------------------------------------------------------------------------------


# Main script
echo "Welcome to the grocery store!"
echo "Please choose a category: (1) Vegetables (2) Fruits"
read -r category_choice

# Set files based on category choice
case $category_choice in
    1)
        category="Vegetables"
        products_file="$1"
        prices_file="$2"
        ;;
    2)
        category="Fruits"
        products_file="$3"
        prices_file="$4"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Display products based on category
display_products "$category" "$products_file" "$prices_file"

selected_products=()
selected_prices=()
while true; do
    echo "Choose the number of the product you want to buy (0 to finish, -1 to edit cart):"
    read -r product_number

    if [ "$product_number" -eq 0 ]; then
        break
    elif [ "$product_number" -eq -1 ]; then
        while true; do
            echo "Current Cart:"
            for ((i=0; i<${#selected_products[@]}; i++)); do
                echo "$((i+1)). ${selected_products[$i]} - ${selected_prices[$i]}"
            done
            echo "Enter the number of the product you want to remove (0 to go back):"
            read -r remove_product_number
            if [ "$remove_product_number" -eq 0 ]; then
                break
            elif [ "$remove_product_number" -le ${#selected_products[@]} ]; then
                index=$((remove_product_number - 1))
                removed_product="${selected_products[index]}"
                removed_price="${selected_prices[index]}"
                unset 'selected_products[index]'
                unset 'selected_prices[index]'
                selected_products=("${selected_products[@]}")
                selected_prices=("${selected_prices[@]}")
                echo "Removed $removed_product - ${removed_price} from the cart."
            else
                echo "Invalid product number."
            fi
        done
    elif [ "$product_number" -le $(wc -l < "$products_file") ]; then
        product=$(sed -n "${product_number}p" "$products_file")
        price=$(sed -n "${product_number}p" "$prices_file")
        selected_products+=("$product")
        selected_prices+=("$price")
        echo "Added $product - ${price} to the cart."
    else
        echo "Invalid product number."
    fi

    echo "Do you want to add more products? (y/n)"
    read -r choice
    if [ "$choice" != "y" ]; then
        break
    fi
done

# Calculate total amount and display
total_amount=$(calculate_total | grep -oP '(?<=: ).*')

#delivery service
echo "Do you want delivery service? (y/n)"
read -r delivery_choice

if [ "$delivery_choice" == "y" ]; then
    delivery_choice="Yes"
else
    delivery_choice="No"
fi

#customer name
echo "Enter your name:"
read -r customer_name

# Save invoice
save_invoice "$5"
