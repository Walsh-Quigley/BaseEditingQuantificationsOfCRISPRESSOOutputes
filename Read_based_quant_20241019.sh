

#editing quanification loop
for DIR in */; do

    #move into the directory
    cd "$DIR";

    #get the directory name
    directoryName=$(basename "$DIR")

    #turn the name into a search term for searching the spreadsheet
    searchTerm=$(echo "$directoryName" | awk -F'[-]' '{print $2}')


    #Print the search term so we can have some visibility in the console
    echo "$searchTerm"
    

    ##20241019 New additions to figure out how to do this


    #grab relevant variables
    guideSeqVar=$(awk -F',' -v searchTerm="$searchTerm" '$1 == searchTerm {print $2}' ./../Common_amplicon_list.csv | tr '[:lower:]' '[:upper:]' | tr -d '\r' | tr -d '-' | xargs | cut -c1-20 )
    ampSeqVar=$(awk -F',' -v searchTerm="$searchTerm" '$1 == searchTerm {print $5}' ./../Common_amplicon_list.csv | tr '[:lower:]' '[:upper:]' | tr -d '\r' | xargs)
    guideOrientation=$(awk -F',' -v searchTerm="$searchTerm" '$1 == searchTerm {print $4}' ./../Common_amplicon_list.csv | tr '[:lower:]' '[:upper:]' | tr -d '\r' | xargs)
    intendedEditIndex=$(awk -F',' -v searchTerm="$searchTerm" '$1 == searchTerm {print $9}' ./../Common_amplicon_list.csv )
    PermissibleEditIndex=$(awk -F',' -v searchTerm="$searchTerm" '$1 == searchTerm {print $8}' ./../Common_amplicon_list.csv )

    echo "LINE 29: This is the Index of the Intended Edit: $intendedEditIndex"
    echo "LINE 30: The silent or tolerated bystanders are at positions: $PermissibleEditIndex"

        PermissibleEditArray=($PermissibleEditIndex)

    # Print the array elements
    echo "LINE 36: The silent or tolerated bystanders are at positions: ${PermissibleEditArray[@]}"


    # Check if the character at intendedEditIndex in guideSeqVar is "A"
    # `Adjust index to be 0-based for Bash string indexing
    index=$((intendedEditIndex - 1))

    # Extract the character at the intendedEditIndex position from guideSeqVar
    charAtIndex=${guideSeqVar:$index:1}

    # Compare the character with "A"
    if [[ "$charAtIndex" == "A" ]]; then
        echo "The character at position $intendedEditIndex in guideSeqVar is A."
    else
        echo "The character at position $intendedEditIndex in guideSeqVar is not A, it's $charAtIndex."
    fi

    # Check if guideSeqVar has "A" at any of the PermissibleEditIndex positions
    echo "Checking PermissibleEditIndex positions in guideSeqVar..."
    for permissibleIndex in "${PermissibleEditArray[@]}"; do
        index=$((permissibleIndex - 1))  # Convert 1-based index to 0-based
        charAtPermissibleIndex=${guideSeqVar:$index:1}
        
        if [[ "$charAtPermissibleIndex" == "A" ]]; then
            echo "The character at position $permissibleIndex in guideSeqVar is A."
        else
            echo "The character at position $permissibleIndex in guideSeqVar is not A, it's $charAtPermissibleIndex."
        fi
    done



    # #Print these variables so we have visibility in the console
    # echo "line 68, guideSeqVar: $guideSeqVar"
    # echo "line 69, ampSeqVar: $ampSeqVar"
    # echo "line 70, guideOrientatino: $guideOrientation"
    
    # #create an empty array to store the positions of our relevant character
    # positions=()

    # #starts with the assumption of searching for 'A's in the forward orientation
    # targetChar="A"
    # sedCommand='4!d'

    # echo "line 78: $sedCommand"

    # #changes this assumption if the guide is in the reverse orientation relative to the amplicon
    # if [[ "$guideOrientation" == "R" ]]; then
    #     targetChar="T"
    #     sedCommand='3!d'
    # fi

    # echo "line 85: $sedCommand"

    # #this grabs the columns of the quantification table and turns it into a string because this is how CRISPResso's output works
    # editingWindow=$(head -n 1 ./*/quantification_window_nucleotide_percentage_table.txt | tr -d '\t')

    # #we then loop through the editing window seeing which characters match our target character, 'A' for ABEs in the forward orientation
    # for ((i=1; i<=${#editingWindow}; i++)); do
    #     char="${editingWindow:i-1:1}"        
                                           
    #     if [[ "$char" == "$targetChar" ]]; then
    #         positions+=($i)
    #     fi
    # done

    # #prints in the terminal the positions that are recognized as matching
    # echo "Positions of '${targetChar}' after for loop: ${positions[@]}"

    # #turns this into text to later add to a column in a spreadsheet for more visibility to users of this code
    # positionsText=$(echo "Positions of '${targetChar}': ${positions[@]}")

    # #generates another array to store values of each position previously identified
    # extracted_values=()


    # # Loop through positions array, extract values, and store them
    # for pos in "${positions[@]}"; do
    #     value=$(awk -v col="$pos" '{print $(col+1)}' ./*/quantification_window_nucleotide_percentage_table.txt | sed "$sedCommand")
    #     extracted_values+=("$value")
    # done

    # echo "extracted values: ${extracted_values[*]}" 

    # #print out the contents of CRISPResso_mapping_statistics.txt
    # totalReads=$(awk 'NR==2 {print $1}'  ./*/CRISPResso_mapping_statistics.txt)
    # readsAligned=$(awk 'NR==2 {print $3}'  ./*/CRISPResso_mapping_statistics.txt)


    # # Combine searchTerm with extracted values and write to CSV
    # final="$directoryName,$searchTerm,$totalReads,$readsAligned,$guideOrientation,$targetChar,$guideSeqVar,$editingWindow,$positionsText,$(IFS=,; echo "${extracted_values[*]}")"
    # echo "$final" >> ./../Editing_Frequency.csv


    #move back out of the directory to the main directory
    cd ..;

done

# #add a header to our table
# echo -e "directoryName,sample,totalReads,readsAligned,guideOrientation,targetCharacter,guideSequence,editingWindow,positions" | cat - Editing_Frequency.csv > temp && mv temp Editing_Frequency.csv

