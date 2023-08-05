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
        read -p "Plesse Entre DB Name: " dbname
        if [ -d $dbname ];then
            echo "the name was exist"
        else
            case $dbname in
                *['!&()'@#$%^*_+]*)
                    echo "dont accept special charcters >>Plesse Entre valid Name"
                    ;;
                [0-9]*)
                    echo "dont accept number at first"
                    ;;
                +([a-zA-Z0-9]))
                    mkdir ./dbs/$dbname
                    ;;        
                *)
                    # mkdir ./dbs/$dbname
                ;;        
            esac
            
        fi       
        ;;
#-------------------------------------------------------------------------------------------------#


#----------------------------------LIST DATABASE--------------------------------------------------#
    2)
        ls -F ./dbs | grep /
        ;;
#-------------------------------------------------------------------------------------------------#


#-----------------------------------DROP DATABSAE-------------------------------------------------#
    3)
        echo "drop"    
        ;;
    4)
#-------------------------------------------------------------------------------------------------#


#---------------------------------CONNECT TO DATABASE---------------------------------------------#
        echo "connect"    
        ;;
    *) 
        echo "wrong choise >> Plesse select from 1 to 4"    
    esac


done