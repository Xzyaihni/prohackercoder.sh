#!/bin/sh

clear

type_color="\e[38;5;121m"
comment_color="\e[38;5;051m"
number_color="\e[38;5;201m"
keyword_color="\e[38;5;226m"

coding_speed=0.2

indent_depth=1
max_indent=5

echo -e "$type_color""int\e[m main()"
echo "{"

variable_pick_letter()
{
    letter_num=$(($RANDOM % 26 + 97))

    awk "BEGIN{printf \"%c\", $letter_num}"
}

variable_pick_name()
{
    variable_type=$(($RANDOM % 2))
    case $variable_type in
    0)
        #buzz word
        buzz_words=("chunk" "stream" "bytes" "var" "database" "initializer" "fragment" "network" "hardware" "driver" "tool" "target" "virtual" "script" "password" "username" "account" "bank" "index" "register" "delimeter" "binary" "octal" "spoofer" "encryptor" "protocol" "payload" "rootkit" "wire" "wired" "token" "widget" "core" "blockchain" "info" "keylock" "deep" "learning")
        buzz_words_size=${#buzz_words[@]}

        word_index=$(($RANDOM % $buzz_words_size))

        echo ${buzz_words[$word_index]}
    ;;
    1)
        #unreadable name
        variable_pick_letter
    ;;
    esac
}

variable_pick_index()
{
    unindexed_roll=$(($RANDOM % 3))
    if [[ $unindexed_roll -eq 0 ]]
    then
        echo "$(variable_pick_name)"
    else
        num=$(($RANDOM % 4))
        echo "$(variable_pick_name)$num"
    fi
}

variable_pick()
{
    unprefixed_roll=$(($RANDOM % 3))
    if [[ $unprefixed_roll -eq 0 ]]
    then
        variable_pick_index
    else
        echo "$(variable_pick_name)_$(variable_pick_index)"
    fi
}

type_pick()
{
    types=("int" "size_t" "float" "long" "double" "unsigned" "bool" "unsigned long")
    types_size=${#types[@]}

    type_index=$(($RANDOM % types_size))

    echo ${types[$type_index]}
}

verb_pick()
{
    verbs=("accessing" "getting" "processing" "compiling" "compile" "bruteforcing" "undo" "redo" "return" "executing" "execute" "wiring" "ameliorate" "crack" "transpose" "retrieving" "suppressing" "hashing" "rehashing" "segmenting")
    verbs_size=${#verbs[@]}

    verb_index=$(($RANDOM % $verbs_size))

    echo ${verbs[$verb_index]}
}

continuation_pick()
{
    continuation=$(($RANDOM % 3))
    case $continuation in
    0)
        echo ".$(variable_pick)"
    ;;
    1)
        num=$(($RANDOM % 10))
        echo -e "[$number_color$num\e[m]"
    ;;
    2)
        echo "->$(variable_pick)"
    ;;
    esac
}

arithmetic_pick()
{
    arithmetic=$(($RANDOM % 7))
    case $arithmetic in
    0)
        echo '+'
    ;;
    1)
        echo '-'
    ;;
    2)
        echo '*'
    ;;
    3)
        echo '/'
    ;;
    4)
        echo '&'
    ;;
    5)
        echo '^'
    ;;
    6)
        echo '|'
    ;;
    esac
}

operator_pick()
{
    operator=$(($RANDOM % 6))
    case $operator in
    0)
        echo "=="
    ;;
    1)
        echo "!="
    ;;
    2)
        echo ">"
    ;;
    3)
        echo "<"
    ;;
    4)
        echo "<="
    ;;
    5)
        echo ">="
    ;;
    esac
}

print_indent()
{
    for ((i=0; i<$indent_depth; i++))
    do
        echo -n "    "
    done
}

indenting_pick()
{
    num=$(($RANDOM%20))
    num_limit=$(($RANDOM%250))
    picked_letter=$(variable_pick_letter)

    indent_roll=$(($RANDOM % 3))

    case $indent_roll in
    0)
        if [[ $(($RANDOM%2)) -eq 0 ]]
        then
            step_operator="++"
        else
            step_operator="--"
        fi

        echo -e "$keyword_color""for\e[m($type_color$(type_pick)\e[m $picked_letter=$number_color$num\e[m; $picked_letter$(operator_pick)$number_color$num_limit\e[m; $picked_letter$step_operator)"
    ;;
    1)
        echo -e "$keyword_color""if\e[m($(variable_pick)$(operator_pick)$number_color$num_limit\e[m)"
    ;;
    2)
        echo -e "$keyword_color""while\e[m($(variable_pick)$(operator_pick)$number_color$num_limit\e[m)"
    ;;
    esac
}

indent_raw()
{
    print_indent
    echo "{"

    indent_depth=$(($indent_depth + 1))
}

function_add()
{
    print_indent

    if [[ $(($RANDOM%3)) -eq 0 ]]
    then
        echo -e "$comment_color//$(verb_pick) side effects, deep copy $(variable_pick) before calling\e[m"
    fi

    echo -ne "$type_color$(type_pick)\e[m $(variable_pick_name)_$(variable_pick_name)("

    args_amount=$(($RANDOM % 4))
    for ((i=0; i<$args_amount; i++))
    do
        if [[ $i -ne 0 ]]
        then
            echo -n ", "
        fi

        echo -ne "$type_color$(type_pick)\e[m $(variable_pick)"
    done

    echo ")"

    indent_raw
}

indent_add()
{
    print_indent
    indenting_pick

    indent_raw
}

indent_sub()
{
    indent_depth=$(($indent_depth - 1))
    
    print_indent
    echo "}"
}

while :
do
    line_type=$(($RANDOM % 8))

    case $line_type in
    0)
        #empty lines
        echo ""  
    ;;
    1|2|3|4)
        #normal lines
        print_indent

        if [[ $(($RANDOM % 4)) -eq 0 ]]
        then
            echo -ne "$type_color$(type_pick) \e[m"
        fi

        picked_variable=$(variable_pick)
        echo -n "$picked_variable"

        separators_amount=$(($RANDOM % 5 + 1))
        for ((i=0; i<$separators_amount; i++))
        do
            echo -n "$(continuation_pick)"
        done
        echo -n " = "

        echo -n "$(variable_pick)$(arithmetic_pick)$(variable_pick)"

        echo -n ";"

        #comments
        if [[ $(($RANDOM % 4)) -eq 0 ]]
        then
            echo -ne " $comment_color//$(verb_pick) $(variable_pick)"

            conversion_roll=$(($RANDOM % 3))
            if [[ $conversion_roll -eq 0 ]]
            then
                echo -n " to $(variable_pick)"
            fi

            echo -e "\e[m"
        fi

        echo ""
    ;;
    5|6)
        print_indent
        echo -n "$(variable_pick_name)_$(variable_pick_name)();"

        if [[ $(($RANDOM % 2)) -eq 0 ]]
        then
            echo -ne " $comment_color//$(verb_pick) $(variable_pick)"

            if [[ $(($RANDOM%3)) -eq 0 ]]
            then
                echo -n ", $(verb_pick) if necessary"
            fi

            echo -e "\e[m"
        fi

        echo ""
    ;;
    7)
        if [[ $indent_depth -eq $max_indent ]]
        then
            indent_sub
        else
            if [[ $(($RANDOM%2)) -eq 0 ]]
            then
                indent_add
            else
                indent_sub
                if [[ $indent_depth -eq 0 ]]
                then
                    echo ""
                    function_add
                fi
            fi
        fi
    ;;
    esac

    sleep $coding_speed
done
