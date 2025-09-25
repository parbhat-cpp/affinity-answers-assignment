#!/bin/bash

echo "Starting extraction process..."

input_file="input.txt"
file_url="https://portal.amfiindia.com/spages/NAVAll.txt"

# download text file if it does not exists locally
if [ ! -f "$input_file" ]; then
    echo "Downloading file"
    curl $file_url -o $input_file
    echo "Download complete (Please re-run to execute script)"
else
    echo "Reading input file..."

    # getting first line of file which contains column names
    columns=$(head -n 1 $input_file)
    columns="${columns//;/$'\t'}"
    columns="Company Name"$'\t'"$columns"

    # read from text file using regex
    filename_pattern='^[[:alnum:][:space:]]+\([[:alnum:][:space:]&-]+\)$'
    company_name_pattern='^[[:alnum:][:space:]]+$'
    row_pattern='^[[:alnum:][:space:]._-]+;[[:alnum:][:space:]._-]+;[[:alnum:][:space:]._-]+;[[:alnum:][:space:]._-]+;[[:alnum:][:space:]._-]+;[[:alnum:][:space:]._-]+$'

    filename=""
    file_data="$columns"$'\n'
    current_company_name=""

    # iterating on the text file
    while IFS= read -r line; do
        clean_line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        if [[ $clean_line =~ $filename_pattern ]]; then
            echo "Extracting data for $clean_line"
            if [[ -z "$filename" ]]; then
                filename=$clean_line
                echo "" > "$filename.tsv"
            elif [[ $filename != $clean_line ]]; then
                printf "%s\n" "$file_data" >> "$filename.tsv"
                filename=$clean_line
            fi
            file_data="$columns"$'\n'
        elif [[ $clean_line =~ $company_name_pattern ]]; then
            current_company_name=$clean_line
        elif [[ $clean_line =~ $row_pattern ]]; then
            row="${clean_line//;/$'\t'}"
            file_data="$file_data"$'\n'"$current_company_name"$'\t'"$row"
        fi
    done < <(tail -n +3 "$input_file")
fi
