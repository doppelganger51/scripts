#!/bin/bash

BOARD=("1" "2" "3" "4" "5" "6" "7" "8" "9")

# choose which player starts the game
if [[ $(($RANDOM % 2)) -eq 0 ]]
then
    PLAYER="X"
else
    PLAYER="O"
fi

OVER=0
GAME_MODE=1
COUNTER=0
SAVE_FILE_NAME=""
ERROR_FILE_MESSAGE=0

function draw_board {
    for A in {0..2}
    do
        for B in {0..2}
        do
            if [ $B != 0 ]
            then
                echo -n "|"
            fi
            echo -n " ${BOARD[3*$A+$B]} "
        done
        echo
        if [ $A != 2 ]
        then
            echo  "------------"
        fi
    done  
}

function change_player {
    if [ ${PLAYER} == "X" ] 
    then
        PLAYER="O"
    else
        PLAYER="X"
    fi
}

function make_move_player {
    while [ true ]
    do
        clear
        echo "Player ${PLAYER}, please make your choice (input available number 1-9). Save the game with S, LOAD the game with L"
        if [ ${ERROR_FILE_MESSAGE} != 0 ]
        then
            echo "There is no save file for this game mode"
            ERROR_FILE_MESSAGE=0
        fi
        echo
        draw_board
        echo
        read FIELD
        if [ ${FIELD} == "S" ]
        then
            if [ ${GAME_MODE} == 1 ] 
            then
                SAVE_FILE_NAME="./saveSinglePlayer.txt"
            else
                SAVE_FILE_NAME="./saveMultiPlayer.txt"
            fi
            echo ${BOARD[0]} > ${SAVE_FILE_NAME}
            for A in {1..8}
            do
                echo ${BOARD[$A]} >> ${SAVE_FILE_NAME}
            done
            echo ${PLAYER} >> ${SAVE_FILE_NAME}
            continue
        fi
        if [ ${FIELD} == "L" ]
        then
            if [ ${GAME_MODE} == 1 ] 
            then
                SAVE_FILE_NAME="./saveSinglePlayer.txt"
            else
                SAVE_FILE_NAME="./saveMultiPlayer.txt"
            fi
            if [ -e ${SAVE_FILE_NAME} ]; then
                COUNTER=0
                for WERS in $(cat ${SAVE_FILE_NAME})
                do
                    if [ ${COUNTER} == 9 ]
                    then
                        PLAYER=$WERS
                        continue
                    fi
                    BOARD[$COUNTER]=$WERS
                    COUNTER=`expr $COUNTER + 1`
                done
            else
                ERROR_FILE_MESSAGE=1
            fi
            continue
        fi
        FIELD=$((FIELD-1))
        if [[ FIELD -le 8 && FIELD -ge 0 && ${BOARD[$FIELD]} != "X" && ${BOARD[$FIELD]} != "O" ]]
        then
            break
        fi
    done
    BOARD[$FIELD]=${PLAYER}
}

function make_move_si {
    clear
    echo "Player ${PLAYER}, please make your choice (input available number 1-9)"
    echo
    draw_board
    sleep 2
    while [ true ]
    do
        FIELD=$((1+$RANDOM % 9))
        FIELD=$((FIELD-1))
        if [[ FIELD -le 8 && FIELD -ge 0 && ${BOARD[$FIELD]} != "X" && ${BOARD[$FIELD]} != "O" ]]
        then
            break
        fi
    done
    BOARD[$FIELD]=${PLAYER}
}

function make_move {
    if [[ ${PLAYER} == "O" && GAME_MODE -eq 1 ]]
    then
        make_move_si
    else
        make_move_player
    fi
}

function check_winner {
    #diagonal win
    if [[
        ( ${BOARD[0]} == ${PLAYER} && ${BOARD[4]} == ${PLAYER} && ${BOARD[8]} == ${PLAYER} ) ||
        ( ${BOARD[2]} == ${PLAYER} && ${BOARD[4]} == ${PLAYER} && ${BOARD[6]} == ${PLAYER} ) 
    ]]
    then
        OVER=1
    fi
    
    for A in {0..2}
    do
        if [[ 
            # horizontal win
            ( ${BOARD[$((3*A))]} == ${PLAYER} && ${BOARD[$((3*A+1))]} == ${PLAYER} && ${BOARD[$((3*A+2))]} == ${PLAYER} ) ||
            # vertical win
            ( ${BOARD[$A]} == ${PLAYER} && ${BOARD[$A+3]} == ${PLAYER} && ${BOARD[$A+6]} == ${PLAYER} )
         ]]
        then
            OVER=1
        fi
    done

    if [[ ${OVER} -eq 1 ]]
    then
        clear
        draw_board
        echo
        echo "Player ${PLAYER} won, congratulations!"
        OVER=1
    fi

    if [[ ${COUNTER} -eq 8 && OVER -ne 1  ]]
    then
        clear
        OVER=1
        draw_board
        echo
        echo "Draw, nobody won"
    fi
}
clear
echo "Welcome to game!
As singleplayer, your sign is \"X\"
Do you want to play singleplayer(1) or multiplayer(2)? Please input corresponding number"
read GAME_MODE
while [[ ${OVER} -eq 0 ]] 
do
    make_move
    check_winner
    change_player
    COUNTER=$((COUNTER+1))
done