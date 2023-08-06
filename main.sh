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
    mainMenu;
}
#-------------------------------------------------------------------------------------------------#
function listDBs {
    if [ -z "$(ls -A ./dbs)" ];then
        echo "NO DATABASE CREATED"
    else    
        ls -F ./dbs | grep /
    fi       
    mainMenu;
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
    mainMenu;
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
    read -p "Plesse Entre Table Name: " tnamee2 
    tname2="${tnamee2// /_}"
    if [ -f $tname2 ];then
        echo "the name was exist"
        tableMenu;
    else
        case $tname2 in
            *['!&()'@#$%^*+]*)
                echo "dont accept special charcters >> Plesse Entre valid Name"
                tableMenu
                ;;
            [0-9]*)
                echo "dont accept number at first"
                tableMenu
                ;;       
            *)
                read -p "Plesse Entre Number of column: " ncol
                if [[ $ncol =~ ^[0-9]+$ ]];then
                    counter=1
                    sep=":"
                    pKey="";
                    rSep="\n";
                    metaData="Field"$sep"Type"$sep"key";
                    while [[ $counter -le $ncol ]]
                    do
                        read -p "Name of Column No.$counter " colname
                        case $colname in
                            *['!&()'@#$%^*+]*)
                                echo "dont accept special charcters >> Plesse Entre valid Name"
                                tableMenu
                                ;;
                            [0-9]*)
                                echo "dont accept number at first"
                                tableMenu
                                ;;       
                            *)
                                select xx in "Integer" "String"
                                do
                                    case $REPLY in
                                    1) coltype="int"; break;;
                                    2) coltype="str"; break;;
                                    *) tableMenu;;
                                    esac
                                done
                                if [[ $pKey == "" ]];then
                                    select yy in "PK" "Not PK"
                                    do
                                        case $REPLY in
                                            1) pKey="PK"; metaData+=$rSep$colname$sep$coltype$sep$pKey; break;;
                                            2) metaData+=$rSep$colname$sep$coltype$sep""; break;;
                                            *) metaData+=$rSep$colname$sep$coltype$sep""; break;;
                                        esac
                                    done
                                else
                                    metaData+=$rSep$colname$sep$coltype$sep"";
                                fi    
                                if [[ $counter == $ncol ]]
                                then
                                    temp=$temp$colname;
                                else
                                    temp=$temp$colname$sep;
                                fi    
                                ;;
                        esac    
                        ((counter++))
                    done
                    touch $tname2 .$tname2;
                    echo -e $metaData  >> .$tname2;
                    echo -e $temp >> $tname2;
                    tableMenu
                else
                    echo "Entre Just Numbers"
                    tableMenu
                fi    
                ;;        
        esac
    fi
}
#-------------------------------------------------------------------------------------------------#
function listTables {
    if [ -z "$(ls -A )" ];then
        echo "NO DATABASE CREATED"
    else    
        ls -d !(*.*)
    fi
    tableMenu;
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
    tableMenu;
}
#-------------------------------------------------------------------------------------------------#
# function insert {

# }
# #-------------------------------------------------------------------------------------------------#
# function deleteFromTable {

# }
# #-------------------------------------------------------------------------------------------------#
# function updateTable {

# }
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
# function selectAll {

# }
# #-------------------------------------------------------------------------------------------------#
# function selectColumn {

# }
# #-------------------------------------------------------------------------------------------------#
# function selectRecord {

# }
#-------------------------------------------------------------------------------------------------#    


mainMenu

