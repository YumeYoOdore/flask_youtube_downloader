import time
import subprocess
import os

from flask import *

app = Flask(__name__)

@app.route('/', methods=['POST', 'GET'])
def home():
    if request.method == 'POST':
        user_query = request.form['target_url']
        convert_checkbox = request.form.get('mp3')

        if not convert_checkbox:
            convert_checkbox = "off"

        subprocess.run(["./yt_downloader.sh", user_query, convert_checkbox])
        
        return redirect(url_for('download', name = f'{user_query}&mp3={convert_checkbox}'))
    else:
        return render_template('main.html')


@app.route('/download', methods=['GET', 'POST'])
def download():
    try:
        filename = ""
        for file in os.listdir(os.path.join(os.getcwd(), 'out')):
            filename = file
            
        file_path = os.path.join(os.getcwd(), 'out', filename)
        return send_file(file_path, as_attachment=True)
    except Exception as e:
        return str(e)

if __name__ == '__main__':
    app.run()
