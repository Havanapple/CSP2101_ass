#!/bin/bash 

# Peter Whitehead
# 10466917

function randgen () {                   # Declaring the randgen function
    randRange=$((($2-$1)+1));           # Using the parameters to define the range of the random num generator (+1 ensures range is inclusive of floor and ceiling)
    randNum=$RANDOM;                    # $RANDOM used to generate a random number
    let "randNum %= $randRange";        # Modular arithmetic used with Random number and range size to generate random number within range
    randNum=$(($randNum+$1));           # Adds the new random number to the floor of the range ensuring the generated number falls within the range.
}

function validate () {                                  # This function ensures the input is an integer between two given values
    while true; do                                      # While loop breaks only when valid input has been entered
    read -p " " choice                                  # Generic prompt allows function to be used in various situations
    if [[ $choice =~ ^[0-9]+$ && $choice -ge $1 && $choice -le $2 ]]; then     # If user input is between parameter 1 and parameter 2:
        return $choice                                  # Output of the function is the user input
        break
    else
        echo -e "\n${Red}Error: ${Clear}Input should be an integer between $1 and $2 (inclusive)\nTry again: \c" # If input is not an integer between those numbers, it prompts user to try again.
    fi
    done
}

Red='\033[31m'              # Colour codes assigned to variables
Green='\033[32m'
Yellow='\033[93m'
Purple='\033[35m'
Clear='\033[0m'

while true; do    # Begins the over arching while loop that allows the game to be replayed after completion.
    echo -e "${Purple}.:: Welcome to the age guessing game! ::.\n${Clear}Please choose a difficulty:\n${Green}1. Easy\n${Yellow}2. Normal\n${Red}3. Hard${Clear}" # Splash screen
    echo -e "Enter a number:\c"
    validate 1 3                    # Prompt user to choose a difficulty and validates their choice using the validate function.
    userDiff=$?                     # user difficulty is saved to a variable
    
    if [[ $userDiff = 1 ]]; then                        # This If/elif structure is for printing user feedback on their difficulty choice.
        echo -e "${Green}\nEASY MODE${Clear}"
    elif [[ $userDiff = 2 ]]; then
        echo -e "${Yellow}\nNORMAL MODE${Clear}"
    else
        echo -e "${Red}\nHARD MODE${Clear}"
    fi

    guesses=$(( 12 - 2*$userDiff )) #  Subtracts user difficulty choice x2 from 12 to calculate number of guesses

    randgen 18 80           # Random number is generated between 18 and 80 using the randgen function
    answer=$randNum         # Random number assigned to answer variable

    echo -e "Can you guess how old I am? (Hint: I am between 18 and 80 years old)"
    until [[ $userInput = $answer || $guesses = 0 ]];       # Until loop breaks if answer is found or guesses run out.
    do
        if [[ $guesses = 1 ]]; then
            guessMsg="${Red}1${Clear} guess"                # If guesses remaining is 1, colour is red, word change to "guess" instead of "guesses"
        elif [[ $guesses -le 3 ]]; then
            guessMsg="${Yellow}$guesses${Clear} guesses"    # If guesses remaining is less than or equal to 3, colour is yellow
        else    
            guessMsg="${Green}$guesses${Clear} guesses"     # If guesses remaining is above 3, colour is green.
        fi
        echo -e "you have $guessMsg remaining" # Prints number of guesses available
        echo -e "Take a guess:\c"
        validate 18 80  # Prompts user for a guess and validates input
        userInput=$?    # Input assigned to userInput variable

        if [[ $userInput -lt $answer ]]; then          # \
            echo -e "${Yellow}Too low!${Clear}\n"      #  |  This section calculates whether the user's guess was too low or
        elif [[ $userInput -gt $answer ]]; then        #  |  too high, and notifies them.
            echo -e "${Yellow}Too high!${Clear}\n"     # /
        else
            continue
        fi

        (( guesses-- ))    # Decrements the guess counter

    done
    if [[ $userInput = $answer ]]; then
        echo -e "${Green}Congratulations:${Yellow} $answer ${Clear}was the correct answer!" # Response if the user input is the correct answer
    else
        echo -e "${Red}Sorry:${Clear} you ran out of guesses. I am ${Yellow}$answer${Clear} years old."   # Response if the user has run out of guesses.
    fi
    echo -e "\nWould you like to play again?\n${Green}1. Yes\n${Red}2. No\n${Clear}Enter a number:\c" # Play again prompt
    validate 1 2                # Prompts user for yes or no (1 or 2) input.
    if [[ $? = 2 ]]; then       # If this condition is met (user enters 2), the over arching while loop is broken and the game ends.
        break
    fi    
done
echo -e "${Green}Thanks for playing!\nGoodbye!" # Exit message
exit 0