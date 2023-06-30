import mysql.connector

conn=mysql.connector.connect(host='localhost',username='root',password='MySQl$3157re@w',database='fimssample')
my_cursor=conn.cursor()
#my_cursor.execute("SELECT * FROM form_keys")
my_cursor.callproc("get_formkeys")


showresult=my_cursor.stored_results()

for result in showresult:
    rlist=result.fetchall()
    for row in rlist:
        print (row)


conn.commit()
conn.close()

