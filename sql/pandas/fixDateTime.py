import csv
from datetime import datetime

with open('D:\\Documents\\MovieData\\ratings.csv', newline='', encoding='utf-8') as file:
    reader = csv.reader(file)
    firstRow = True
    for row in reader:
        with open('C:\\docker356\\project\\UserRatings.csv', 'a', newline='', encoding='utf-8') as csvfile:
            myWriter = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            if firstRow != True:
                myWriter.writerow([row[0], row[1], row[2], datetime.utcfromtimestamp(int(row[3])).strftime('%Y-%m-%d %H:%M:%S')])
            else:
                myWriter.writerow([row[0], row[1], row[2], row[3]])
                firstRow = False