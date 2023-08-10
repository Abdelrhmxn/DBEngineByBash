# /bin/bash
LANG=C
LC_COLLATE=C
shopt -s extglob
#---------------------------------------------------------------------------------------------------------------#
if [ -d dbs ];then
    echo  
else
    mkdir dbs
fi
#---------------------------------------------------------------------------------------------------------------#
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
#---------------------------------------------------------------------------------------------------------------#
function createDB {
    read -p "Plesse Entre DB Name: " dbNamee 
    dbName="${dbNamee// /_}"
    if [[ ! -n $dbName ]];then
        echo "EMPTY INPUT"
        mainMenu;
    fi    
    if [ -d ./dbs/$dbName ];then
        echo "the name was exist"
    else
        case $dbName in
            *['!&()'@#$%^*+]*)
                echo "dont accept special charcters >> Plesse Entre valid Name"
                ;;
            [0-9]*)
                echo "dont accept number at first"
                ;;       
            *)
                mkdir ./dbs/$dbName
                ;;        
        esac
    fi
    mainMenu;
}
#---------------------------------------------------------------------------------------------------------------#
function listDBs {
    if [ -z "$(ls -A ./dbs)" ];then
        echo "NO DATABASE CREATED"
    else    
        ls -F ./dbs | grep /
    fi       
    mainMenu;
}
#---------------------------------------------------------------------------------------------------------------#
function dropDB {
    select dbName in $(ls ./dbs)
    do
        dbNum=$(ls ./dbs |wc -l)
        if [ $REPLY -gt $dbNum ];then
            echo "Invalid Choise Entre From 1 to $dbNum"
            mainMenu
        fi
        if [ -d ./dbs/$dbName  ];then
            rm -r ./dbs/$dbName
            mainMenu
        fi
    done  
    mainMenu;
}
#---------------------------------------------------------------------------------------------------------------#
function selectDB {
    select dbName in $(ls ./dbs)
    do
        dbNum=$(ls ./dbs |wc -l)
        if [ $REPLY -gt $dbNum ];then
            echo "Invalid Choise Entre From 1 to $dbNum"
            mainMenu
        fi
        if [ -d ./dbs/$dbName ];then
            cd ./dbs/$dbName
            tableMenu;
        else
            echo "NO DATABASE WITH THIS NAME" 
        fi
    done        
}
#---------------------------------------------------------------------------------------------------------------#
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
#---------------------------------------------------------------------------------------------------------------#
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
#---------------------------------------------------------------------------------------------------------------#
function listTables {
    if [ -z "$(ls -A )" ];then
        echo "NO DATABASE CREATED"
    else    
        ls -d !(*.*)
    fi
    tableMenu;
}
#---------------------------------------------------------------------------------------------------------------#
function dropTable  {
    select tableName in $(ls)
    do
        tableNum=$(ls |wc -l)
        if [ $REPLY -gt $tableNum ];then
            echo "Invalid Choise Entre From 1 to $tableNum"
            tableMenu
        fi
        if [ -f $tableName ];then
            rm $tableName
            tableMenu   
        fi 
    done
    tableMenu;
}
#---------------------------------------------------------------------------------------------------------------#
function insert {
    select tableName in $(ls)
    do
        tableNum=$(ls |wc -l)
        if [ $REPLY -gt $tableNum ];then
            echo "Invalid Choise Entre From 1 to $tableNum"
            tableMenu
        fi
        colsNum=$(awk 'END{print NR}' .$tableName);
        sep=":";
        rSep="\n";
        for (( i = 2; i <= $colsNum; i++ ))
        do
            colName=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $1}' .$tableName);
            colType=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $2}' .$tableName);
            colKey=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' .$tableName);
            read -p "Plesse Entre Value Of Column $colName : " data 
            if [[ $colType == "int" ]];then
                while ! [[ $data =~ ^[0-9]+$ ]]
                do
                    echo "Invalid Data Type"
                    read -p "Plesse Entre Value Of Column $colName : " data
                done
            fi
            if [[ $colKey == "PK" ]];then
                while [[ true ]]
                do
                    if [[ $data =~ ^[$(awk 'BEGIN{FS=":"; ORS=" "}{if(NR!=1) print $(('$i'-1))}' $tableName 2>> /dev/null)]$ ]]
                    then
                        echo "Invalid Input for PK"
                        read -p "Plesse Entre Value Of Column $colName : " data
                    else
                        break;
                    fi
                done
            fi
            if [[ $i == $colsNum ]]
            then
                row=$row$data$rSep;
            else
                row=$row$data$sep;
            fi
        done  
        echo -e $row"\c" >> $tableName;
        row=""    
        tableMenu;
    done
}
#---------------------------------------------------------------------------------------------------------------#
function deleteFromTable {
    select tableName in $(ls)
    do
        tableNum=$(ls |wc -l)
        if [ $REPLY -gt $tableNum ];then
            echo "Invalid Choise Entre From 1 to $tableNum"
            tableMenu
        fi
        colsNum=$(awk 'END{print NR}' .$tableName);
        for (( i = 2; i <= $colsNum; i++ ))
        do
            colName=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $1}' .$tableName);
            colKey=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' .$tableName);
            ((fID=$i-1));
            if [[ $colKey == "PK" ]]
            then
                break;
            fi
        done    
        read -p "Plesse Entre Value of primary key: " pkValue
        if [[ $pkValue != "" ]]
        then
            res=$(awk 'BEGIN{FS=":"}{if($'$fID'=="'$pkValue'") print $'$fID'}' $tableName);
            if [[ $res != "" ]]
            then
                NR=$(awk 'BEGIN{FS=":"}{if($'$fID'=="'$pkValue'") print NR}' $tableName);
                sed -i ''$NR'd' $tableName 2>> /dev/null;
                if [[ $? == 0 ]]
                then
                    echo "Row Deleted Successfully"
                else
                    echo "Error Deleting Data From Table $tableName"
                fi
            else
                echo "Value not Found"
            fi
        fi 
        tableMenu       
    done
}
#---------------------------------------------------------------------------------------------------------------#
function updateTable {
    select tableName in $(ls)
    do
        tableNum=$(ls |wc -l)
        if [ $REPLY -gt $tableNum ];then
            echo "Invalid Choise Entre From 1 to $tableNum"
            tableMenu
        fi
        colsNum=$(awk 'END{print NR}' .$tableName);
        for (( i = 2; i <= $colsNum; i++ ))
        do
            colName=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $1}' .$tableName);
            colKey=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' .$tableName);
            ((fID=$i-1));
            if [[ $colKey == "PK" ]]
            then
                break;
            fi
        done
        read -p "Plesse Entre Value of primary key: " pkValue
        if [[ $pkValue != "" ]]
        then
            res=$(awk 'BEGIN{FS=":"}{if($'$fID'=="'$pkValue'") print $'$fID'}' $tableName);
            if [[ $res != "" ]]
            then
                select setField in $(awk 'BEGIN{FS=":"; ORS=" "}{if(NR!=1) print $1}' .$tableName)
                do
                    if [[ $setField != "" ]];then
                        setFid=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1; i<=NF; i++){if($i=="'$setField'") print i}}}' $tableName)
                        read -p "Plesse Entre The New Value: " newValue
                        NR=$(awk 'BEGIN{FS=":"}{if($'$fID'=="'$pkValue'") print NR}' $tableName)  
                        oldValue=$(awk 'BEGIN{FS=":"}{if(NR=='$NR'){for(i=1; i<=NF; i++){if(i=='$setFid') print $i}}}' $tableName)
                        sed -i ''$NR's/'$oldValue'/'$newValue'/g' $tableName 2>> /dev/null;
                        if [[ $? == 0 ]]
                        then
                            echo "Row Updated Successfully"
                            tableMenu
                        else
                            echo "Error Updating Data From Table $tableName"
                            tableMenu
                        fi
                    fi     
                done
            else
                echo "Value not Found"
            fi
        fi
        tableMenu
    done
}
#---------------------------------------------------------------------------------------------------------------#
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
#---------------------------------------------------------------------------------------------------------------#
function selectAll {
    select tableName in $(ls)
    do
        tableNum=$(ls |wc -l)
        if [ $REPLY -gt $tableNum ];then
            echo "Invalid Choise Entre From 1 to $tableNum"
            selectMenu
        fi
        if [[ $tableName != "" ]];then
            allRecords=$(awk 'BEGIN{FS=":"}{if(NR!=1){for(i=1; i<=NF; i++){print $i}}}' $tableName);
            if [[ $allRecords != "" ]];then
                echo "---- List of Records ------"
                cat $tableName | column -t -s ":"
                echo -e "---------------------------"
            else
                echo "Table is Empty"
            fi    
        fi
        selectMenu
    done
}
#---------------------------------------------------------------------------------------------------------------#
function selectColumn {
    select tableName in $(ls)
    do
        tableNum=$(ls |wc -l)
        if [ $REPLY -gt $tableNum ];then
            echo "Invalid Choise Entre From 1 to $tableNum"
            selectMenu
        fi
        if [[ $tableName != "" ]];then
            select setField in $(awk 'BEGIN{FS=":"; ORS=" "}{if(NR!=1) print $1}' .$tableName)
            do
                if [[ $setField != "" ]];then
                    setFid=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1; i<=NF; i++){if($i=="'$setField'") print i}}}' $tableName)
                    columnRecords=$(awk 'BEGIN{FS=":"}{if(NR!=1) print $'$setFid'}' $tableName)
                    if [[ $columnRecords != "" ]]
                    then
                        # field=$(awk -F"\n" 'BEGIN{FS=":"}{if(NR!=1) print $'$setFid'}' $tableName)
                        # echo $field
                        
                        awk -F"\n" 'BEGIN{FS=":"}{if(NR!=1) print $'$setFid'}' $tableName
                        selectMenu
                    else
                        echo "Table is Empty"
                        selectMenu
                    fi
                fi
            done
        fi
        selectMenu
    done
}
#---------------------------------------------------------------------------------------------------------------#
function selectRecord {
    select tableName in $(ls)
    do
        tableNum=$(ls |wc -l)
        if [ $REPLY -gt $tableNum ];then
            echo "Invalid Choise Entre From 1 to $tableNum"
            selectMenu
        fi
        if [[ $tableName != "" ]];then
            colsNum=$(awk 'END{print NR}' .$tableName)
            for (( i = 2; i <= $colsNum; i++ ))
            do
                colName=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $1}' .$tableName)
                colKey=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' .$tableName)
                ((fID=$i-1));
                if [[ $colKey == "PK" ]]
                then
                    break;
                fi
            done
            read -p "Enter Value of PK: " pkValue
            if [[ $pkValue != "" ]]
            then
                res=$(awk 'BEGIN{FS=":"}{if($'$fID'=="'$pkValue'") print $'$fID'}' $tableName);
                if [[ $res != "" ]]
                then
                fields=$(awk 'BEGIN{FS=":"; ORS=" "}{if(NR!=1) print $1}' .$tableName)
                recordss=$(awk 'BEGIN{FS=":"}{if(NR!=1 && $'$fID'=='$pkValue'){for(i=1; i<=NF; i++){print $i}}}' $tableName)
                echo $fields
                echo $recordss                
                else
                    echo "Value not Found"
                fi
            fi    
        fi
        selectMenu
    done
}
#---------------------------------------------------------------------------------------------------------------#    


mainMenu

