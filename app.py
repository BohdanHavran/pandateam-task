from flask import Flask, jsonify, render_template

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/health', methods=['GET'])
def health():
    return jsonify(status="OK"), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)