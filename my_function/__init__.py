import json
import requests
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    body = req.get_json()
    search_id = body.get('id')
    url = f"https://jsonplaceholder.typicode.com/posts/{search_id}"
    resp = requests.get(url)
    data = json.dumps(resp.json())
    return func.HttpResponse(data, status_code=200, mimetype="application/json")
