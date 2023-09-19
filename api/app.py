from flask import Flask, render_template, request, jsonify
import redis

app = Flask(__name__)
redis_client = redis.StrictRedis(host='redis', port=6379, db=0, decode_responses=True)

def fibonacci(index):
    if index < 2:
        return 1
    return fibonacci(index - 1) + fibonacci(index -2)
    

@app.route('/')
def index():
    # redis_client.flushdb()
    return render_template('index.html')


@app.route('/calculate_fibonacci', methods=['POST'])
def calculate_fibonacci():
    try:
        if request.method == 'POST': 
            n = int(request.form['n'])
            if n < 40:
                fib_result = fibonacci(n)
                redis_client.set(n, fib_result)
                return jsonify(
                    {'success': True, 'fibonacci_series': fib_result}
                    ), 200
            else:
                return render_template('index.html', message=f"{n} too high number to compute")
        else:
            return "Form not submitted."        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/get_cached_result', methods=['GET'])
def get_cached_result():
    cached_result = {}
    try:
        redis_keys = redis_client.keys("*")
        for key in redis_keys:
            cached_result[key] = redis_client.get(key)
        cached_result = cached_result
        if cached_result:
            return render_template('index.html', data=cached_result)
        else:
            return jsonify({'success': False, 'message': 'Result not found in cache.'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 501

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
