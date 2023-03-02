ampelikiotisAM="5714"
kolovosAM="5793"
cmd0=$0
cmd1=$1
cmd2=$2
cmd3=$3
cmd4=$4
cmd5=$5
cmd6=$6

#--------------------Ερώτημα 1o-----------------------------------
#./tool.sh Όταν εκτελούμε χωρίς παράμετρο το πρόγραμμα εκτυπώνει
#μόνο τα ΑΜ(παλιοί ΑΜ)
if [[ $# -eq 0 ]]
    then
    echo "$ampelikiotisAM-$kolovosAM"
fi

##################################################################

#./tool.sh -f <file> εκτύπωση όλου του αρχείου
if [[ $cmd1 == "-f" ]] && [[ $cmd3 == "" ]]
    then
    #χρησιμοποιούμε grep με άρνηση για να εκτυπώσει όσες γραμμές
    #δεν ξεκινούν με #
    grep -v '^#' $cmd2
fi
##################################################################
##################################################################


#--------------------Ερώτημα 2o-----------------------------------
#--------------------Functions------------------------------------
#Function που το χρησιμοποιούμε για κάθε σάρωση γραμμής του αρχείου
id_function(){
    #grep για την γραμμή που ξεκινάει με το id που ψάχνουμε και 
    #παράλληλα αντικαθιστούμε τα κενά με _ και τα | με κενά για 
    #να λειτουργήσει παρακάτω η set και να χωρίζονται τα tokens 
    #με κενά
    #όπου $1 είναι το id που δόθηκε και $2 το όνομα του αρχείου
    line="$(grep ^$1 $2 | tr ' ' '_' | tr '|' ' ' )"
}

#Παίρνουμε όλες τις περιπτώσεις για το πως θα δοθεί η εντολή
#./tool.sh -f <file> -id <id> 
if [[ $cmd1 == "-f" ]] && [[ $cmd3 == "-id" ]]
    then
    #καλούμε την id_function δίνοντας τα κατάλληλα args
    id_function "$cmd4" "$cmd2" 
    #set για να ξεχωρίσουμε τα τοκεν της γραμμής ώστε να διαλέξουμε
    #αυτά που ζητούνται
    set -- $line
    #εκτυπώνει τα ζητούμενα
    echo "$2 $3 $5"
fi

#./tool.sh -id <id> -f <file>
if [[ $cmd1 == "-id" ]] && [[ $cmd3 == "-f" ]]
    then
    id_function "$cmd2" "$cmd4" 
    set -- $line
    echo "$2 $3 $5"
fi
#Για αυτό το ερώτημα δεν χρειάζεται να παραλείψουμε τα σχόλια στο
#αρχείο γιατί ψάχνουμε με συγκεκριμένο id

##################################################################
##################################################################


#--------------------Ερώτημα 3o-----------------------------------
#--------------------Functions------------------------------------
#Function που καλούμε κάθε φορά που πρέπει να αγνοήσουμε σχόλια
ignore_comments(){
    #Πιάνουμε κάθε μία γραμμή από το αρχείο που θα δοθεί ως arg $1
    line="$(sed "${i}q;d" $1)"
    #Αν η γραμμή ξεκινάει με #(είναι σχόλιο) πήγαινε στην επόμενη
    if [[ ${line::1} == "#" ]]
    then
        i=$((i+1))
    fi
}

make_output(){
    #Διαλέγουμε τη γραμμή και παράλληλα αντικαθιστούμε τα κενά με _ 
    #και τα | με κενά για να λειτουργήσει παρακάτω η set και να 
    #χωρίζονται τα tokens με κενά ώστε να ξέρουμε τις θέσεις τους
    line="$(sed "${i}q;d" $1 | tr ' ' '_' |tr '|' ' ')" 
}

#Για την εκτύπωση και το σορτάρισμα χρησιμοποιούμε ένα 'προσωρινό'
#αρχείο το οποίο στη συνέχεια διαγράφουμε
sort_and_destroy(){
    #Σορτάρισμα και εκτύπωση
    cat output.txt | sort
    #Διαγραφή
    rm output.txt
}

#Πιάνουμε όλες τις περιπτώσεις για την εντολή
#./tool.sh --firstnames -f <file>
if [[ $cmd1 == "--firstnames" ]] && [[ $cmd2 == "-f" ]]
    then
    #Λούπα για να σκανάρουμε μια μια τις γραμμές του αρχείου
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd3"
        make_output "$cmd3"
        set -- $line
        #διαλέγουμε το τοκεν που ζητείται, ξέρουμε τη θέση του, 
        #και το βάζουμε στο προσωρινό αρχείο
        echo $3 >> output.txt
        #Η λούπα τερματίζει όταν η γραμμή που θα σκανάρει είναι
        #'κενή'
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
    #καλούμε για να γίνει σορτάρισμα-εκτύπωση και Διαγραφή του
    #προσωρινού
    sort_and_destroy
fi

#την ίδια διαδικασία ακολουθούμε για όλες τις περιπτώσεις και για
#τα επίθετα

#./tool.sh -f <file> --firstnames
if [[ $cmd1 == "-f" ]] && [[ $cmd3 == "--firstnames" ]]
    then
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd2"
        make_output "$cmd2"
        set -- $line
        echo $3 >> output.txt
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
    sort_and_destroy
fi

##################################################################
  
#./tool.sh --lastnames -f <file>
if [[ $cmd1 == "--lastnames" ]] && [[ $cmd2 == "-f" ]]
    then
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd3"
        make_output "$cmd3"
        set -- $line
        echo $2 >> output.txt
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
    sort_and_destroy
fi

#./tool.sh -f <file> --lastnames
if [[ $cmd1 == "-f" ]] && [[ $cmd3 == "--lastnames" ]]
    then
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd2"
        make_output "$cmd2"
        set -- $line
        echo $2 >> output.txt
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
    sort_and_destroy
fi
##################################################################
##################################################################


#--------------------Ερώτημα 4o-----------------------------------
#--------------------Functions------------------------------------
#Functions για να συγκρίνουμε τις ημερομηνίες για κάθε περίπτωση αν
#η σύγκριση αληθεύει εκτυπώνει τη γραμμή
#Όταν δίνονται και οι δύο
since_until(){
    if [[ $date > $dateA ]] && [[ $date < $dateB ]]
    then
        printf "$(sed "${i}q;d" $1)\n"
    fi
}

#Όταν δίνεται μόνον μία
since(){
    if [[ $date > $dateA ]]
    then
        printf "$(sed "${i}q;d" $1)\n"
    fi
}

_until(){
    if [[ $date < $dateA ]]
    then
        printf "$(sed "${i}q;d" $1)\n"
    fi
}

#Όλες οι περιπτώσεις όταν δοθούν και οι δύο ημερομηνίες
#./tool.sh --born-since <dateA> --born-until <dateB> -f <file>
if [[ $cmd1 == "--born-since" ]] && [[ $cmd3 == "--born-until" ]]
    then
    #Αλλάζουμε τη μορφή των ημερομηνιών που δόθηκαν ώστε να μπορεί να
    #γίνει σύγκριση(πχ 12-01-1985 --> 12011985 )
    dateA=${cmd2//-/}
    dateB=${cmd4//-/}
    
    #Λούπα για να σκανάρουμε μια μια γραμμή
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd6"
        make_output "$cmd6"
        #Προκειμένου να βρούμε στη γραμμή που είναι η ημερομηνία
        set -- $line
        #Αλλάζουμε τη μορφή της για να τη συγκρίνουμε
        date=${5//-/}
        #Καλούμε για να γίνει η σύγκριση
        since_until "$cmd6"
        #Λούπα τερματίζει αν η γραμμή είναι 'κενή'
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
    
fi

#Για όλες τις υπόλοιπες περιπτώσεις η διαδικασία είναι η ίδια απλώς
#καλούμε τις απαραίτητες Functions βάζοντας τα σωστά args

#./tool.sh --born-since <dateA> -f <file> --born-until <dateB>
if [[ $cmd1 == "--born-since" ]] && [[ $cmd5 == "--born-until" ]]
    then
    dateA=${cmd2//-/}
    dateB=${cmd6//-/}
    
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd4"
        make_output "$cmd4"
        set -- $line
        date=${5//-/}
        since_until "$cmd4"
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
    
fi

#./tool.sh --born-until <dateB> --born-since <dateA> -f <file>
if [[ $cmd1 == "--born-until" ]] && [[ $cmd3 == "--born-since" ]]
    then
    dateA=${cmd4//-/}
    dateB=${cmd2//-/}
    
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd6"
        make_output "$cmd6"
        set -- $line
        date=${5//-/}
        since_until "$cmd6"
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
    
fi

#./tool.sh --born-until <dateB> -f <file> --born-since <dateA>
if [[ $cmd1 == "--born-until" ]] && [[ $cmd5 == "--born-since" ]]
    then
    dateA=${cmd6//-/}
    dateB=${cmd2//-/}
    
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd4"
        make_output "$cmd4"
        set -- $line
        date=${5//-/}
        since_until "$cmd4"
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
    
fi

#./tool.sh -f <file> --born-since <dateA> --born-until <dateB>
if [[ $cmd3 == "--born-since" ]] && [[ $cmd5 == "--born-until" ]]
    then
    dateA=${cmd4//-/}
    dateB=${cmd6//-/}
    
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd2"
        make_output "$cmd2"
        set -- $line
        date=${5//-/}
        since_until "$cmd2"
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
    
fi

#./tool.sh -f <file> --born-until <dateB> --born-since <dateA>
if [[ $cmd6 == "--born-since" ]] && [[ $cmd3 == "--born-until" ]]
    then
    dateA=${cmd6//-/}
    dateB=${cmd4//-/}
    
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd2"
        make_output "$cmd2"
        set -- $line
        date=${5//-/}
        since_until "$cmd2"
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
    
fi

##################################################################

#./tool.sh --born-since <dateA> -f <file>
if [[ $cmd1 == "--born-since" ]] && [[ $cmd3 == "-f" ]]
    then
    dateA=${cmd2//-/}
    
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd4"
        make_output "$cmd4"
        set -- $line
        date=${5//-/}
        since "$cmd4"
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
fi

#./tool.sh -f <file> --born-since <dateA> 
if [[ $cmd1 == "-f" ]] && [[ $cmd3 == "--born-since" ]]
    then
    dateA=${cmd4//-/}
    
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd2"
        make_output "$cmd2"
        set -- $line
        date=${5//-/}
        since "$cmd2"
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
fi

##################################################################

#./tool.sh --born-until <dateB> -f <file>
if [[ $cmd1 == "--born-until" ]] && [[ $cmd3 == "-f" ]]
    then
    dateA=${cmd2//-/}
    
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd4"
        make_output "$cmd4" 
        set -- $line
        date=${5//-/}
        _until "$cmd4"
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
fi

#./tool.sh -f <file> --born-until <dateB> 
if [[ $cmd1 == "-f" ]] && [[ $cmd3 == "--born-until" ]]
    then
    dateA=${cmd4//-/}
    
    for (( i=1; ; i++ ))
    do
        ignore_comments "$cmd2"
        make_output "$cmd2" 
        set -- $line
        date=${5//-/}
        _until "$cmd2"
        if [[ -z "$line" ]] 
        then
            break
        fi
    done
fi
##################################################################
##################################################################


#--------------------Ερώτημα 5o-----------------------------------
#--------------------Functions------------------------------------
#όταν εντοπιστεί το ίδιο όνομα που θα δοθεί το βάζουμε στο προσωρινό
#αλλά το τοποθετούμε σε αλφαβητική σειρά.
socialmedia(){
    echo "$1 $(grep -o $1 $2 | wc -l)" >> output.txt
}

#Παίρνουμε όλες τις περιπτώσεις για την εντολή
#./tool.sh --socialmedia -f <file>
if [[ $cmd1 == "--socialmedia" ]] && [[ $cmd2 == "-f" ]]
    then
    #Καλούμε την function με ορίσματα το όνομα που ψάχνουμε και το
    #αρχείο μέσα στο οποίο αναζητούμε
    socialmedia "Facebook" "$cmd3"
    socialmedia "Facebook" "$cmd3"
    socialmedia "Twitter" "$cmd3"
    socialmedia "Google+" "$cmd3"
    socialmedia "Youtube" "$cmd3"
    socialmedia "Instagram" "$cmd3"
    socialmedia "Flickr" "$cmd3"
    socialmedia "LinkedIn" "$cmd3"
    socialmedia "Blogger" "$cmd3"
    sort_and_destroy
fi

#./tool.sh -f <file> --socialmedia 
if [[ $cmd1 == "-f" ]] && [[ $cmd3 == "--socialmedia" ]]
    then
    socialmedia "Facebook" "$cmd2"
    socialmedia "Facebook" "$cmd2"
    socialmedia "Twitter" "$cmd2"
    socialmedia "Google+" "$cmd2"
    socialmedia "Youtube" "$cmd2"
    socialmedia "Instagram" "$cmd2"
    socialmedia "Flickr" "$cmd2"
    socialmedia "LinkedIn" "$cmd2"
    socialmedia "Blogger" "$cmd2"
    sort_and_destroy
fi

##################################################################
#--------------------Functions------------------------------------
#Χρησιμοποιήσαμε την body γιατί υπήρξε πρόβλημα με τα τοκεν όταν 
#χρησιμοποιούσαμε τη set
body(){
    id=$1 #του χρήστη
    column=$2 #η στήλη που αλλάζει (2-8)
    value=$3 #η αντικατάσταη που δίνεται
    #ο αριθμός της γραμμής στην οποία βρίσκεται το id του χρήστη
    #που δόθηκε
    noline=$(grep -n $id $4| grep -Eo '^[^:]+')
    #Διαλέγουμε τη γραμμή και παράλληλα αντικαθιστούμε τα κενά με _ 
    #και τα | με κενά για να λειτουργήσει παρακάτω η set και να 
    #χωρίζονται τα tokens με κενά ώστε να ξέρουμε τις θέσεις τους
    line="$(sed "${noline}q;d" $5 | tr ' ' '_' |tr '|' ' ')"
}

#Παίρνουμε όλες τις περιπτώσεις για την εντολή
#./tool.sh -f <file> --edit <id> <column> <value>
if [[ $cmd1 == "-f" ]] && [[ $cmd3 == "--edit" ]]
    then
    #Βάζουμε τα ορίσματα που δόθηκαν
    body "$cmd4" "$cmd5" "$cmd6" "$cmd2" "$cmd2"
    set -- $line
    #για να χωριστεί η γραμμή σε τοκεν με κενά
    #Παίρνουμε περιπτώσεις για το $column
    case "$column" in
    2)
        #όπου previous θα είναι το περιεχόμενο πριν την αλλαγή
        #αν το column που δόθηκε είναι 2 τότε Παίρνουμε το 2ο τοκεν και το
        #βαζουμε στο previous
        #το ίδιο για όλες τις περιπτώσεις
        previous=$2
        ;;
    3) 
        previous=$3
        ;;
    4)
        previous=$4
        ;;
    5)
        previous=$5
        ;;
    6)
        previous=$6
        ;;
    7)
        previous=$7
        ;;
    8)
        previous=$8
        ;;
    *)
        #σε περιπτωση που ο χρήστης δωσει κάτι εκτός απο [2,8] τότε 
        #εκτυπώνει μηνυμα λάθους και τερματίζει το πρόγραμμα
        printf "ERROR!\n"
        exit 0
        ;;
    esac
    
    #τέλος αντικαθιστούμε στη γραμμη που βρήκαμε το $previous με το $value
    #στο αρχείο που δόθηκε στην εντολή $cmd2
    sed -i ""$noline"s/"$previous"/"$value"/" $cmd2
fi

#./tool.sh --edit <id> <column> <value> -f <file> 
if [[ $cmd1 == "--edit" ]] && [[ $cmd5 == "-f" ]]
    then
    body "$cmd2" "$cmd3" "$cmd4" "$cmd6" "$cmd6"
    set -- $line
    case "$column" in
    2)
        previous=$2
        ;;
    3) 
        previous=$3
        ;;
    4)
        previous=$4
        ;;
    5)
        previous=$5
        ;;
    6)
        previous=$6
        ;;
    7)
        previous=$7
        ;;
    8)
        previous=$8
        ;;
    *)
        printf "ERROR!\n"
        exit 0
        ;;
    esac
    
    sed -i ""$noline"s/"$previous"/"$value"/" $cmd6
fi
