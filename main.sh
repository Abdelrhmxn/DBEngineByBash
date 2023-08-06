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
    read -p "Plesse Entre DB Name: " dbnamee3 
    dbname3="${dbnamee3// /_}"
    case $dbname3 in
        *['!&()'@#$%^*+]*)
            echo "dont accept special charcters >>Plesse Entre valid Name"
            ;;
        [0-9]*)
            echo "dont accept number at first"
            ;;       
        *)
            if [ -d ./dbs/$dbname3 ];then
                cd ./dbs/$dbname3
                tableMenu;
            else
                echo "NO DATABASE WITH THIS NAME" 
            fi
    esac        
}
#-------------------------------------------------------------------------------------------------#
function tableMenu {
    select y in "Create Table" "List Table" "Drop Table" "Insert Table" "Select" "Delete" "Update" "Back To Main Menu" "Exit"
    do
        case $REPLY in
            1) createTable;;
            2) listTables;;
            3) dropTable;;
            4) insert;;
            5) selectMenu;;
            6) deleteFromTable;;
            7) updateTable ;;
            8) cd ../..; mainMenu;;
            9) exit;;
        esac
    done
}
#-------------------------------------------------------------------------------------------------#
function createTable {
    
}
#-------------------------------------------------------------------------------------------------#
function listTables {
    if [ -z "$(ls -A )" ];then
        echo "NO DATABASE CREATED"
    else    
        ls -d !(*.*)
    fi
}
#-------------------------------------------------------------------------------------------------#
function dropTable  {
    read -p "Plesse Entre Table Name: " tnamee
    tname="${tnamee// /_}"
    
    case $tname in
        *['!&()'@#$%^*+]*)
            echo "dont accept special charcters >>Plesse Entre valid Name"
            ;;
        [0-9]*)
            echo "dont accept number at first"
            ;;       
        *)
            if [ -f $tname ];then
                rm $tname
            else
                echo "Not exist"    
            fi    
            ;;
    esac
}
#-------------------------------------------------------------------------------------------------#
function insert {

}
#-------------------------------------------------------------------------------------------------#
function deleteFromTable {

}
#-------------------------------------------------------------------------------------------------#
function updateTable {

}
#-------------------------------------------------------------------------------------------------#
function selectMenu {
    select z in "Select All" "Select a Column" "Select a Record" "Back To Table Menu" "Back To Main Menu" "Exit"
    do
        case $REPLY in
            1) selectAll;;
            2) selectColumn;;
            3) selectRecord;;
            4) tableMenu;;
            5) cd ../..; mainMenu;;
            6) exit;;
        esac
    done

}
#-------------------------------------------------------------------------------------------------#
function selectAll {

}
#-------------------------------------------------------------------------------------------------#
function selectColumn {

}
#-------------------------------------------------------------------------------------------------#
function selectRecord {

}
#-------------------------------------------------------------------------------------------------#    


mainMenu

