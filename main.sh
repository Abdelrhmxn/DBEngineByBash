# /bin/bash
LANG=C
LC_COLLATE=C
shopt -s extglob
#-------------------------------------------------------------------------------------------------#
if [ -d dbs ];then
    echo  
else
    mkdir dbs
    cd dbs    
fi
#-------------------------------------------------------------------------------------------------#
select x in "Create DB" "List DB" "Drop DB" "Connect DB"
do 
    case $REPLY in
#------------------------------------CREATE DATABSE------------------------------------------------#
    1)
        read -p "Plesse Entre DB Name: " dbnamee 
        dbname="${dbnamee// /_}"
        if [ -d ./dbs/$dbname ];then
            echo "the name was exist"
        else
            case $dbname in
                *['!&()'@#$%^*+]*)
                    echo "dont accept special charcters >>Plesse Entre valid Name"
                    ;;
                [0-9]*)
                    echo "dont accept number at first"
                    ;;       
                *)
                    mkdir ./dbs/$dbname
                ;;        
            esac
            
        fi       
        ;;
#-------------------------------------------------------------------------------------------------#


#----------------------------------LIST DATABASE--------------------------------------------------#
    2)
        if [ -d dbs ];then
            if [ -z "$(ls -A ./dbs)" ];then
                echo "NO DATABASE CREATED"
            else    
                ls -F ./dbs | grep /
            fi
        else
            mkdir dbs
            echo "NO DATABASE CREATED"
        fi        
        ;;
#-------------------------------------------------------------------------------------------------#


#-----------------------------------DROP DATABSAE-------------------------------------------------#
    3)
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

        ;;
    4)
#-------------------------------------------------------------------------------------------------#


#---------------------------------CONNECT TO DATABASE---------------------------------------------#
        echo "connect"    
        ;;
#-------------------------------------------------------------------------------------------------#

    *) 
        echo "wrong choise >> Plesse select from 1 to 4"    
    esac


done