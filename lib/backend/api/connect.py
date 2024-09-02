from flask import Flask, jsonify
import mysql.connector

app = Flask(__name__)

# เชื่อมต่อกับ MySQL
db = mysql.connector.connect(
    host="127.0.0.1",
    user="root",
    password="",
    database="thesis"
)

@app.route('/api/data', methods=['GET'])
def get_data():
    cursor = db.cursor()
    cursor.execute("SELECT name FROM teachers")  # ดึงเฉพาะชื่อ
    result = cursor.fetchall()
    names = [row[0] for row in result]  # แปลงข้อมูลเป็นลิสต์ของชื่อ
    return jsonify(names)

if __name__ == '__main__':
    app.run(debug=True)
