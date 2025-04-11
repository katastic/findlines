#!/bin/bash

# Function to calculate Shannon entropy of a string
calculate_entropy() {
    local word="$1"
    local length=${#word}
    local entropy=0
    
    # If string is too short, return 0 entropy
    if [ $length -lt 2 ]; then
        echo "0"
        return
    fi
    
    # Create associative array for character frequencies
    declare -A char_count
    
    # Count frequency of each character
    for ((i=0; i<length; i++)); do
        char="${word:$i:1}"
        ((char_count["$char"]++))
    done
    
    # Calculate entropy: H = -∑(p*log2(p))
    for count in "${char_count[@]}"; do
        probability=$(bc -l <<< "scale=10; $count/$length")
        log_term=$(bc -l <<< "scale=10; l($probability)/l(2)")
        entropy=$(bc -l <<< "scale=10; $entropy - ($probability * $log_term)")
    done
    
    echo "$entropy"
}

# Function to check if string is a likely human word
is_human_word() {
    local word="$1"
    word=$(echo "$word" | tr -d '[:space:]')
    
    if [[ ${#word} -ge 2 && ${#word} -le 20 && "$word" =~ [aeiouAEIOU] ]]; then
        if ! [[ "$word" =~ ^[0-9]+$ ]] && ! [[ "$word" =~ \.[a-zA-Z]{1,4}$ ]]; then
            return 0
        fi
    fi
    return 1
}

# Function to check if string is an acronym
is_acronym() {
    local word="$1"
    word=$(echo "$word" | tr -d '[:space:]')
    
    if [[ "$word" =~ ^[A-Z]{2,8}$ ]]; then
        return 0
    fi
    return 1
}

# Function to check if string has a file extension
has_file_extension() {
    local word="$1"
    if [[ "$word" =~ \.[a-zA-Z]{1,4}$ ]]; then
        return 0
    fi
    return 1
}

# Counter variables
total_lines=0
human_words=0
acronyms=0
extensions=0
high_entropy=0

# Process input line by line
while IFS= read -r line || [[ -n "$line" ]]; do
    ((total_lines++))
    
    words=($line)
    
    for word in "${words[@]}"; do
        # Calculate entropy for the word
        entropy=$(calculate_entropy "$word")
        
        # Check if entropy is high (above 2.5 bits)
        if (( $(bc <<< "$entropy > 2.5") )); then
            echo "High entropy detected: $word (entropy: $entropy)"
            ((high_entropy++))
        fi
        
        if is_human_word "$word"; then
            echo "Human word detected: $word (entropy: $entropy)"
            ((human_words++))
        fi
        
        if is_acronym "$word"; then
            echo "Acronym detected: $word (entropy: $entropy)"
            ((acronyms++))
        fi
        
        if has_file_extension "$word"; then
            echo "File extension detected: $word (entropy: $entropy)"
            ((extensions++))
        fi
    done
done

# Print summary
echo -e "\nAnalysis Summary:"
echo "Total lines processed: $total_lines"
echo "Human words found: $human_words"
echo "Acronyms found: $acronyms"
echo "File extensions found: $extensions"
echo "High entropy strings found: $high_entropy"

exit 0
