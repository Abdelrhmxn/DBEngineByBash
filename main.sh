# /bin/bash
LANG=C
LC_COLLATE=C
shopt -s extglob
#-------------------------------------------------------------------------------------------------#
if [ -d dbs ];then
    echo  
else
    mkdir dbs
fi
#-------------------------------------------------------------------------------------------------#
function mainMenu {
    select x in "Create DB" "List DB" "Connect DB" "Drop DB" "Exit"
    do
        case $REPLY in
            1) createDB;;
            2) listDBs;;
            3) selectDB;;
            4) dropDB;;
            5) exit;;
        esac
    done    
}
#-------------------------------------------------------------------------------------------------#
function createDB {
    read -p "Plesse Entre DB Name: " dbnamee 
    dbname="${dbnamee// /_}"
    if [ -d ./dbs/$dbname ];then
        echo "the name was exist"
    else
        case $dbname in
            *['!&()'@#$%^*+]*)
                echo "dont accept special charcters >> Plesse Entre valid Name"
                ;;
            [0-9]*)
                echo "dont accept number at first"
                ;;       
            *)
                mkdir ./dbs/$dbname
                ;;        
        esac
    fi
}
#-------------------------------------------------------------------------------------------------#
function listDBs {
    if [ -z "$(ls -A ./dbs)" ];then
        echo "NO DATABASE CREATED"
    else    
        ls -F ./dbs | grep /
    fi       
}
#-------------------------------------------------------------------------------------------------#
function dropDB {
    read -p "Plesse Entre DB Name: " dbnamee2
    dbname2="${dbnamee2// /_}"
    
    case $dbname2 in
        *['!&()'@#$%^*+]*)
            echo "dont accept special charcters >>Plesse Entre valid Name"
            ;;
        [0-9]*)
            echo "dont accept number at first"
            ;;       
        *)
            if [ -d ./dbs/$dbname2  ];then
                rm -r ./dbs/$dbname2
            else
                echo "Not exist"    
            fi    
            ;;
    esac  
}
#-------------------------------------------------------------------------------------------------#
function selectDB {

}
#-------------------------------------------------------------------------------------------------#






mainMenu