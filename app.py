from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify({
        'message': 'Hello from Cloud Run! Psitron',
        'version': '1.0.0',
        'environment': os.getenv('ENVIRONMENT', 'production')
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    # Get port from environment variable or default to 8080
    port = int(os.getenv('PORT', 8080))
    
    # Run the app
    app.run(host='0.0.0.0', port=port, debug=False) 