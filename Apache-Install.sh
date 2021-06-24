 
 
#!/bin/bash
# parameter -d : Debug
# parameter -b : Breaks

typeset -i iStep=0
Input1=$1

#Debug
if [[ $Input1 == "-d" ]]; then
{
 set -x;
}
fi;

declare -r False=1;
declare -r True=0;


export TARGET_IP_ADDRESS=0;
export TARGET_USR_NAME=0;
export TARGET_USR_PASSWORD=0;
export TARGET=0;
export TARGET_HOME=/home/$VPN_CLIENT_USR_NAME

declare -i iInput=$False;
declare -i iStatus=$False;
declare -i iStatus1=$False;
declare -i iStatus2=$False;
declare -i iStatus3=$False;
declare -i iStatus4=$False;
declare -i iStatus5=$False;
declare -i iStatus6=$False;

Fct_Apache_Conf()
{
    printf "\n->Fct_Apache_Conf\n";


    printf "\n\n                                !! Additional configurations are necessary please take a look into andreas media wiki !! \n\n";

    
    return $True;
}

Fct_Apache_For_Nextcloud()
{
    printf "\n->Fct_Apache_For_Nextcloud\n";

    TARGET=$TARGET_USR_NAME@$TARGET_IP_ADDRESS;
    
    iStatus1=$False;
    iStatus2=$False;

    #From operation computer to target0
    sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) scp ./nextcloud.conf $TARGET:/tmp
    iStatus1=$?;
    #to the right folder
    sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "echo $TARGET_USR_PASSWORD | sudo -S mv /tmp/nextcloud.conf /etc/httpd/conf.d";    
    iStatus2=$?;

    if [[ $iStatus1 != $True || $iStatus2 != $True ]]; then
    {
        printf "\n Fct_Apache_For_Nextcloud Something went wrong -> iStatus1:$iStatus1 iStatus2:$iStatus2\n";
        return $False;
    }

    printf "\n Done! \n";

    fi;
}


Fct_Apache_Service()
{
    printf "\n->Fct_Apache_Service\n";

    TARGET=$TARGET_USR_NAME@$TARGET_IP_ADDRESS;
    
    iStatus1=$False;
    iStatus2=$False;
    iStatus3=$False;
    iStatus4=$False;
    iStatus5=$False;
    iStatus6=$False;
    iStatus7=$False;
    iStatus8=$False;
    
    sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "systemctl --no-pager status httpd.service";
    iStatus1=$?;
    if [[ $iStatus1 != $True ]]; then
    {
        sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "echo $TARGET_USR_PASSWORD | sudo -S firewall-cmd --permanent --add-service=http";
        iStatus2=$?;
        sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "echo $TARGET_USR_PASSWORD | sudo -S firewall-cmd --permanent --add-service=https";
        iStatus3=$?;
        sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "echo $TARGET_USR_PASSWORD | sudo -S firewall-cmd --reload";
        iStatus4=$?;
        sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "echo $TARGET_USR_PASSWORD | sudo -S systemctl -f start httpd.service";
        iStatus5=$?;
        sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "echo $TARGET_USR_PASSWORD | sudo -S systemctl -f enable httpd.service";
        iStatus6=$?;
        sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "echo $TARGET_USR_PASSWORD | sudo -S systemctl --no-pager status httpd.service";
        iStatus7=$?;
        
        if [[   $iStatus2 != $True || 
                $iStatus3 != $True || 
                $iStatus4 != $True || 
                $iStatus5 != $True || 
                $iStatus6 != $True || 
                $iStatus7 != $True ]]; then
        {
            printf "\n Fct_Apache_Service Something went wrong -> iStatus1:$iStatus1 iStatus2:$iStatus2 iStatus3:$iStatus3 iStatus4:$iStatus4 iStatus5:$iStatus5 iStatus6:$iStatus6 iStatus7:$iStatus7\n";
            return $False;
        }
        fi;
    }
    fi;
    
    
    printf "\n Done! \n";
    
    return $True;
}

Fct_Apache_Install()
{
    printf "\n->Fct_Apache_Install\n";

    TARGET=$TARGET_USR_NAME@$TARGET_IP_ADDRESS;
    
    iStatus1=$False;
    iStatus2=$False;
    iStatus3=$False;

    sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "echo $TARGET_USR_PASSWORD | sudo -S dnf -y update";
    iStatus1=$?;
    if [[ $iStatus1 != $True ]]; then
    {
        printf "\n Fct_Apache_Install Something went wrong -> iStatus1: $iStatus1\n";
        return $False;
    }
    fi;
    sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "echo $TARGET_USR_PASSWORD | sudo -S dnf list installed | grep httpd.x86_64";
    iStatus2=$?;
    if [[ $iStatus2 != $True ]]; then
    {
        sshpass -f <(printf '%s\n' $TARGET_USR_PASSWORD) ssh $TARGET "echo $TARGET_USR_PASSWORD | sudo -S dnf -y install httpd";
        iStatus3=$?;
        if [[ $iStatus3 != $True ]]; then
        {
            printf "\n Fct_Apache_Install Something went wrong -> iStatus3: $iStatus3\n";
            return $False;
        }
        fi;
    }
    fi;
    iStatus2=$True;
    iStatus3=$True;
    
    if [[ $iStatus1 != $True || $iStatus2 != $True || $iStatus3 != $True ]]; then
    {
        printf "\n Fct_Apache_Install Something went wrong -> iStatus1: $iStatus1 iStatus2: $iStatus2 iStatus3: $iStatus3 \n";
        return $False;
    }
    fi;
    return $True;
}

Fct_Dialog_Input_Data()
{
    clear;

    printf "\n\n Input of all necessary data\n\n";
    
    
    printf "\n          Input IP-Address:";
    read TARGET_IP_ADDRESS;
    printf "\n          Input User-Name:";
    read TARGET_USR_NAME;
    printf "\n          Input User-Password:";
    read TARGET_USR_PASSWORD;
}

Fct_Dialog()
{
    #Fct_Dialog_Input_Data;

    TARGET_IP_ADDRESS=192.168.68.253;
    TARGET_USR_NAME=test;
    TARGET_USR_PASSWORD=test;

    printf "\n\n          IP-Address   : $TARGET_IP_ADDRESS\n";
    printf "\n          User-Name    : $TARGET_USR_NAME\n";
    printf "\n          User-Password: $TARGET_USR_PASSWORD\n\n";

    printf "\nPress 1. Apache installation\n";
    printf "\nPress 2. Nextcloud configuration\n";
    printf "\nPress 3. Apache Service\n";
    printf "\nPress 4. For Exit\n";
    
    printf "\nInput:";
    read iInput;
    
    return $True;
}

# Main-Application

    Fct_Dialog;

    case $iInput in
        1)  Fct_Apache_Install;
            iStatus=$?
            if [[ $iStatus == $False ]]; then
            {
                exit $False;
            }
            fi;
            exit $True;
            ;;
            
        2)  Fct_Apache_For_Nextcloud
            iStatus=$?
            if [[ $iStatus == $False ]]; then
            {
                exit $False;
            }
            fi;
            exit $True;
            ;;
        
        3)  Fct_Apache_Service 
            iStatus=$?
            if [[ $iStatus == $False ]]; then
            {
                exit $False;
            }
            fi;
            Fct_Apache_Conf;
            exit $True;
            ;;
        
        4)  echo "Application closed"
            exit $TRUE;
            ;;
        *)  echo "default -> Exit"
            exit $False;
            ;;
    esac;

exit $True;
