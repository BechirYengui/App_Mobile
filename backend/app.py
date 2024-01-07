import sqlite3
import pyodbc
from flask import Flask, jsonify, request, make_response
from flask_cors import CORS, cross_origin

app = Flask(__name__)
CORS(app, origins='*', supports_credentials=True)

# Define connection parameters for SQL Server
server = 'DESKTOP-6F8JMQA\SQLEXPRESS'
database = 'Test'
connection_string = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={database}'

# Connect to the SQL Server database
db_connection = pyodbc.connect(connection_string)
db_cursor = db_connection.cursor()

@app.route('/login', methods=['GET','POST', 'OPTIONS'])
def login():
    data = request.get_json()

    email = data.get('email')
    password = data.get('password')

    # Add your authentication logic here (e.g., check credentials in a database)
    # For simplicity, I'll just check if the email and password are not empty
    if email and password:
        db_connection.commit()
        return jsonify({'success': True, 'message': 'Login successful'})
    else:
        db_connection.commit()
        return jsonify({'success': False, 'message': 'Invalid credentials'})

@app.route('/post-job', methods=['POST'])
def post_job():
    data = request.get_json()

    title = data.get('title')
    description = data.get('description')
    job_type = data.get('job_type')
    field = data.get('field')
    profile_requested = data.get('profile_requested')
    skills_requested = data.get('skills_requested')

    try:
        # Insert job post data into the SQL Server database
        db_cursor.execute("""
            INSERT INTO JobPosts (Title, Description, JobType, Field, ProfileRequested, SkillsRequested)
            VALUES (?, ?, ?, ?, ?, ?)
        """, title, description, job_type, field, profile_requested, skills_requested)
        db_connection.commit()

        return jsonify({'success': True, 'message': 'Job post created successfully'})
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@app.route('/signup', methods=['POST'])
def signup():
    data = request.get_json()

    first_name = data.get('first_name')
    last_name = data.get('last_name')
    localisation = data.get('localisation')
    occupation = data.get('occupation')
    field_of_work = data.get('field_of_work')
    skills = data.get('skills')
    birth_date = data.get('birth_date')
    education = data.get('education')
    diploma = data.get('diploma')
    email = data.get('email')
    password = data.get('password')
    confirm_password = data.get('confirm_password')

    try:
        # Insert user registration data into the SQL Server database
        db_cursor.execute("""
            INSERT INTO Users (FirstName, LastName, Localisation, Occupation, FieldOfWork, Skills,
                               BirthDate, Education, Diploma, Email, Password, ConfirmPassword)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, first_name, last_name, localisation, occupation, field_of_work, skills,
            birth_date, education, diploma, email, password, confirm_password)
        sql_statement = """
            INSERT INTO Users (FirstName, LastName, Localisation, Occupation, FieldOfWork, Skills,
                               BirthDate, Education, Diploma, Email, Password, ConfirmPassword)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """
        print("SQL Statement:", sql_statement)
        db_connection.commit()

        return jsonify({'success': True, 'message': 'User registered successfully'})
    except pyodbc.Error as e:
        db_connection.rollback()
        return jsonify({'success': False, 'message': f'Database error: {str(e)}'})
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

        
@app.route('/search', methods=['POST'])
def search():
    data = request.get_json()

    search_query = data.get('search_query')

    # Add your logic to perform a search based on the provided query
    # For simplicity, I'll just return a response with the search query
    return jsonify({'search_results': f'Searching for "{search_query}"'})

@app.route('/send-message', methods=['POST'])
def send_message():
    data = request.get_json()

    sender_id = data.get('sender_id')
    receiver_id = data.get('receiver_id')
    message_text = data.get('message_text')

    try:
        # Insert message data into the SQL Server database
        db_cursor.execute("""
            INSERT INTO Messages (SenderID, ReceiverID, MessageText, Timestamp)
            VALUES (?, ?, ?, GETDATE())
        """, sender_id, receiver_id, message_text)
        db_connection.commit()

        return jsonify({'success': True, 'message': 'Message sent successfully'})
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@app.route('/get-messages', methods=['POST'])
def get_messages():
    data = request.get_json()

    user_id = data.get('user_id')

    try:
        # Retrieve messages from the SQL Server database based on user_id
        db_cursor.execute("""
            SELECT SenderID, MessageText, Timestamp
            FROM Messages
            WHERE ReceiverID = ? OR SenderID = ?
        """, user_id, user_id)
        messages = db_cursor.fetchall()

        # Convert the messages to a list of dictionaries
        messages_list = [{'sender_id': row.SenderID, 'message_text': row.MessageText, 'timestamp': row.Timestamp}
                         for row in messages]

        return jsonify({'success': True, 'messages': messages_list})
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})
    
    
@app.route('/get-job-details', methods=['POST', 'OPTIONS', 'GET'])
def get_job_details():

    try:
        # Retrieve job details from the database based on job_id
        # Modify the query according to your database schema
        db_cursor.execute("""
            SELECT  Title, Description, JobType, Field, ProfileRequested, SkillsRequested
            FROM JobPosts
        """)
        job_details_list = []

        for row in db_cursor.fetchall():
            job_details_dict = {
                'title': row.Title,
                'description': row.Description,
                'JobType': row.JobType,
                'Field': row.Field,
                'ProfileRequested': row.ProfileRequested,
                'SkillsRequested': row.SkillsRequested,
            }
            job_details_list.insert(0, job_details_dict)
        db_connection.commit()
        return jsonify({'success': True, 'job_details': job_details_list})
    except pyodbc.Error as e:
        db_connection.rollback()
        error_message = str(e)
        print(f'Database error: {error_message}')
        return jsonify({'success': False, 'message': f'Database error: {error_message}'})

    except Exception as e:
        error_message = str(e)
        print(f'Error: {error_message}')
        return jsonify({'success': False, 'message': f'Error: {error_message}'})





@app.route('/send-job-message', methods=['POST'])
def send_job_message():
    data = request.get_json()

    sender_id = data.get('sender_id')
    job_id = data.get('job_id')
    message_text = data.get('message_text')

    try:
        # Insert the job-related message data into the database
        # Modify the query according to your database schema
        db_cursor.execute("""
            INSERT INTO JobMessages (SenderID, JobID, MessageText, Timestamp)
            VALUES (?, ?, ?, GETDATE())
        """, sender_id, job_id, message_text)
        db_connection.commit()

        return jsonify({'success': True, 'message': 'Job-related message sent successfully'})
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@app.route('/get-user-profile', methods=['GET','POST'])
def get_user_profile():
    data = request.get_json()

    email = data.get('email')

    try:
        print("Requête reçue sur /get-job-details")
        # Retrieve user profile data from the SQL Server database based on user_id
        db_cursor.execute("""
            SELECT FirstName, LastName, Job, Birthday, Skills
            FROM Users
            WHERE Email = ?
        """, email)
        user_profile = db_cursor.fetchone()

        # Convert the user profile data to a dictionary
        user_profile_dict = {
            'first_name': user_profile.FirstName,
            'last_name': user_profile.LastName,
            'job': user_profile.Job,
            'birthday': user_profile.Birthday,
            'skills': user_profile.Skills,
        }
        db_connection.commit()
        return jsonify(user_profile_dict)
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)