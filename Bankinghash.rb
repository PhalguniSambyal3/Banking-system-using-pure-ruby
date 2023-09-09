require 'yaml'
require 'bigdecimal'
require 'bigdecimal/util'
#FILE
def file_load
    if(File.exist?("C:/Users/hp/Desktop/Ruby/details.yml"))
        $mainHash = YAML.load_file("details.yml")
    else
       #Dir.mkdir("C:/Users/hp/Desktop/Ruby/details") 
        File.new("C:/Users/hp/Desktop/Ruby/details.yml","w+")
        File.open("C:/Users/hp/Desktop/Ruby/details.yml")    
    end  
end 

def file_write
    File.write("details.yml",$mainHash.to_yaml)
end

def cont
    puts("Enter (y/Y) to continue or (n/N) to exit")
    res= gets().chomp
    until(res=='y' || res=='Y')
        if(res == 'n' || res == 'N')
            exit 
        end
        system('cls') 
        puts("Enter correct key")
        puts("Enter (Y/y) to Continue and (N/n) to exit.")
        res = gets().chomp 
    end    
    start  
end

#CREATE
def create 
    system("cls") 
    file_load
#ACCOUNT_NUMBER 
    acc=(rand(1000...4000))
    puts("Account number: #{acc}")
#NAME
    puts("Name:")
    name = gets.chomp
    until(name.match(/^[a-zA-Z\s]{3,}$/))
        puts("only characters allowed in name and Minimum 3 characters needed")
        puts("Name:")
        name = gets.chomp
    end  
#PIN
    puts("PIN:") 
    pin= gets().chomp
    until(pin.match(/^[0-9]{4,}$/))
        puts("Only digits allowed and Minimum 4 digits PIN needed")
        puts("PIN:")
        pin= gets().chomp
    end 
#USERNAME    
    if(File.empty?("details.yml"))
        puts("UserName:")
        username=gets.chomp
        until(username.match(/^[a-zA-Z0-9\s]{3,}$/))
            puts("only characters and digits allowed in Username and Minimum 3 characters needed") 
            puts("UserName:")
            username = gets.chomp
        end 
    else 
        puts("UserName:")
        username=gets.chomp
        until(!($mainHash.has_key?("#{username}")))
            puts("Username already exists")
            puts("Choose another")
            puts("UserName:")
            username=gets.chomp 
        end 
        until(username.match(/^[a-zA-Z0-9\s]{3,}$/)) 
            puts("only characters and digits allowed in User username and Minimum 3 characters needed") 
            puts("UserName:")
            username = gets.chomp 
        end 
    end
#HASH
    obj={
        "Account"=> acc,
        "Name" => name, 
        "PIN" => pin, 
        "Balance" => 1000
        }  
    if(File.empty?("details.yml"))
        $mainHash={}  
    end
    $mainHash[username]=obj
    file_write                                           #Writing updation (mainhash) in file.             
    puts("Account created.")
    puts("Account opening balance is 1000") 
    cont                                            
end

#LOGIN
def login 
    file_load
#EMPTY FILE  
    puts('Enter username:')
    username=gets().chomp
    until(!(File.empty?("details.yml")))
        # puts("Enter Pin")
        # pin=gets().chomp
        puts("No such account. Please create account first") 
        cont
    end 
#USERNAME
    until($mainHash.has_key?("#{username}"))                                #checking username
        puts('username doesn`t exist.Try again')
        puts('Enter username:')
        username=gets().chomp
    end   
    puts("Enter Pin")
    pin=gets().chomp                               
    until($mainHash[username]['PIN'] == "#{pin}")                           #checking pin        
        puts("PIN does not match. Try Again.") 
        puts("Enter Pin")
        pin=gets().chomp 
    end                                                                                                   
    options(username)
end

#OPTIONS
def options(username)
    name= $mainHash[username]['Name']
    system("cls")                                                          #puts "\e[H\e[2J"
    puts("Hello #{name}")
    puts("1. Deposit")
    puts("2. Withdraw")
    puts("3. Balance")
    puts("4. Exit") 
    login_response = gets().chomp
    if(login_response == '1')
        deposit(username)
    elsif(login_response == '2')
        withdraw(username)
    elsif(login_response == '3')
        balance(username)
    elsif(login_response == '4')
        start
    else
        puts("Choose Correct Option")
        sleep(1)
        options(username) 
    end 
    options(username)  
end

#DEPOSIT 
def deposit(username)
    system("cls")
    old_balance= $mainHash[username]['Balance'] 
    puts("Your Balance is #{old_balance}")
    puts("Enter Amount to deposit:")
    deposit_amt = gets().chomp
    until(deposit_amt.match(/^\d*\.?\d*$/) && (!(deposit_amt == '')))
        puts("Enter Amount in digits only.")
        deposit_amt = gets().chomp
    end
    deposit_amt= deposit_amt.to_d 
    old_balance = old_balance.to_d
    old_balance = (old_balance + deposit_amt).to_f
    $mainHash[username]['Balance']="#{old_balance}"
    file_write
    puts("Thank You")
    balance(username)   
end

#WITHDRAW
def withdraw(username)
    system("cls")
    old_balance= $mainHash[username]['Balance'] 
    puts("Enter Amount To Withdraw")
    withdraw_amt = gets().chomp
    until(withdraw_amt.match(/^\d*\.?\d*$/) && (!(withdraw_amt == ''))) 
        puts("Enter Amount in digits only.")
        withdraw_amt = gets().chomp
    end
    withdraw_amt = withdraw_amt.to_d
    old_balance = old_balance.to_d
    if(old_balance < withdraw_amt)
        puts("INSUFFICIENT BALANCE")
        balance(username) 
    else
        old_balance= (old_balance - withdraw_amt).to_f
        puts("WITHDRAWN SUCCESSFUL")
        $mainHash[username]['Balance']="#{old_balance}"
        file_write
        balance(username)
    end    
end

#BALANCE
def balance(username)
    puts("Your current Balance is: #{$mainHash[username]['Balance']}") 
    puts("Enter (y/Y) to continue or (n/N) to exit")
    res= gets().chomp
    until(res =='y' || res =='Y')
        if(res == 'n' || res == 'N')
            start
        end
        system('cls') 
        puts("Enter correct key")
        puts("Enter (Y/y) to Continue and (N/n) to exit.")
        res = gets().chomp 
    end      
    system("cls")
    options(username)
end 

#START
def start
    system("cls")
    1
    puts("Welcome to Bank")
    puts("1. Create Account")
    puts("2. Login")
    puts("3. Exit")
    response=gets().chomp
    if(response == '1')
        create   
    elsif(response == '2')
        system("cls")
         login
    elsif(response == '3')
        system("cls")
        exit
    else
        puts("Choose correct option")
        sleep(1)
        start
    end
end
start