import psycopg2
import pandas


#sudo pip install psycopg2
#https://wiki.postgresql.org/wiki/Python
def DB_call(request):
        records = []
        colnames = []
        #The try block lets you test a block of code for errors.
        try:
            conn = psycopg2.connect(dbname = 'TechManiacs_DB', host = 'localhost', port = '5432', user = 'postgres',password = 'postgres')

            cur = conn.cursor()
            cur.execute(request)
            if request.upper().startswith('SELECT') :
               
                colnames = [desc[0] for desc in cur.description]
                
                #print("\nSelecting rows using cursor.fetchall..")
                records = cur.fetchall()
            elif request.upper().startswith('UPDATE') or request.upper().startswith('INSERT') or request.upper().startswith('DELETE'):
                updated_rows = cur.rowcount
                conn.commit()
                print(str(updated_rows)+" rows affected.")
        except(Exception, psycopg2.Error) as error:
            print("Error while fetching data from PostgreSQL", error)
            return None,None
        finally:
            if(conn):
                cur.close()
                conn.close()
                print("PostgreSQL connection is closed\n\n")     
        pandas.set_option('display.max_rows',len(records))
        
        return records,colnames


def DB_product_display(area,choice):
    if area =='1':
            answer = DB_call('select product_name,product_quantity \
                             from shop inner join shop_sells on shop.shop_id=shop_sells.shop_id inner join product on product.product_id=shop_sells.product_id \
                             where shop_name =\'TechManiacs Athens\'')
            
            print(pandas.DataFrame(answer[0],columns=answer[1]).reset_index(drop=True, inplace=False))   
    elif area == '2':
            answer = DB_call('select product_name,product_quantity \
                             from shop inner join shop_sells on shop.shop_id=shop_sells.shop_id inner join product on product.product_id=shop_sells.product_id \
                             where shop_name =\'TechManiacs Patra\'')
            print(pandas.DataFrame(answer[0],columns=answer[1]))
    elif area == '3':
            answer = DB_call('select product_name,product_quantity \
                             from shop inner join shop_sells on shop.shop_id=shop_sells.shop_id inner join product on product.product_id=shop_sells.product_id \
                             where shop_name =\'TechManiacs Crete\'') 
            print(pandas.DataFrame(answer[0],columns=answer[1]))
    elif area == '4' and choice== '1':
            answer = DB_call('select product_name,SUM(product_quantity) \
                             from shop inner join shop_sells on shop.shop_id=shop_sells.shop_id inner join product on product.product_id=shop_sells.product_id \
                             group by product_name') 
            print(pandas.DataFrame(answer[0],columns=answer[1]))       
    

while True:
    
    print("\n\n-------TechManiacs DATABASE--------")
    print("\t\t\t\tMenu")
    print("------------------------------------")
    print("|1. Check product quantities.      |")
    print("|2. Update product quantities.     |")
    print("|3. View Revenues for a date range.|")
    print("|4. Custom SQL Command             |")
    print("|5. EXIT                           |")
    print("------------------------------------")
    choice = input("Please make a Choice: ")
    if choice == '1' :
        print('\nPlease enter the number between the following shops\n')
        print("|1.TechManiacs Athens  ")
        print("|2.TechManiacs Patra   ")
        print("|3.TechManiacs Crete   ")
        print("|4.Every Shop          ")
        area = input()
        DB_product_display(area,choice)
        print("\n\nRedirecting to Main Menu...\n\n")
    elif choice == '2' :
        print('Please enter the number between the following shops')
        print("|1.TechManiacs Athens")
        print("|2.TechManiacs Patra")
        print("|3.TechManiacs Crete")
        area = input()
        while area not in ["1","2","3"]:
            print("Invalid Input!")
            print('Please enter the number between the following shops')
            area = input()
        DB_product_display(area,choice)
        while True:
            productName = input("*Please Type the EXACT name of the product you want to edit(type MENU to redirect to main menu:\n")
            answer = DB_call('select from product where product_name ='+"'"+productName+"'")
            if productName == 'MENU':
                break;            
            elif answer[0]== []:
                print("ERROR:Invalid product name.Please try again...\n\n")
            else:
                break;
        if productName != 'MENU' :
            quantity = input("Set the new Quantity for "+productName+": ")
            #while check if quantity is a valid number         
            DB_call("update shop_sells set product_quantity ="+quantity+" where product_id=(select product_id from product where product_name="+"'"+productName+"')")
    elif choice == '3':
        startingDate=input("Insert the starting Date (YYYY-MM-DD): ")
        endingDate = input("Insert the ending Date (YYYY-MM-DD): ")
        print("Displaying all the orders from"+startingDate+" until "+endingDate)
        answer = DB_call('SELECT * FROM ORDERS where orders_creation_date >'+"'"+startingDate+"' and orders_creation_date < "+"'"+endingDate+"' order by orders_creation_date")
        print(pandas.DataFrame(answer[0],columns=answer[1]))
    elif choice == '4':
        print("\n***********CUSTOM SQL**********")
        command_string = input('Please insert your SQL query: ' )
        answer = DB_call(command_string);
        if answer[0]!= None :
            print(pandas.DataFrame(answer[0],columns=answer[1]))
    elif choice == '5':
        print('\nExiting TechManiacs Database....')
        break;