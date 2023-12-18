from flask import Flask, request, render_template
import pymysql

app = Flask(__name__)

# Database Configuration
db_config = {
    'host': '10.7.1.83',  # Replace with your database server's IP
    'user': 'flask_user',                # Replace with your database username
    'password': 'my_password',        # Replace with your database password
    'db': 'my_database'               # Replace with your database name
}

# Route for the form
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        name = request.form['name']
        age = request.form['age']
        country = request.form['country']
        add_entry(name, age, country)
    return render_template('index.html')

# Function to add entry to the database
def add_entry(name, age, country):
    conn = pymysql.connect(**db_config)
    try:
        with conn.cursor() as cursor:
            sql = "INSERT INTO users (name, age, country) VALUES (%s, %s, %s)"
            cursor.execute(sql, (name, age, country))
        conn.commit()
    finally:
        conn.close()

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
