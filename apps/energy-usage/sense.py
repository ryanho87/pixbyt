import requests
import sys

import json

input = json.loads(sys.argv[1])

BASE_URL = input["base_url"]
TOKEN = input["token"]

class HomeAssistantRESTClient:
    def __init__(self, base_url, token):
        self.base_url = f"{base_url}/api"
        self.token = token
        self.headers = {
            'Authorization': f'Bearer {self.token}',
            'Content-Type': 'application/json'
        }

    def _get(self, endpoint):
        url = f"{self.base_url}/{endpoint}"
        response = requests.get(url, headers=self.headers)
        return self._handle_response(response)

    def _post(self, endpoint, data=None):
        url = f"{self.base_url}/{endpoint}"
        response = requests.post(url, headers=self.headers, json=data)
        return self._handle_response(response)
    
    def _put(self, endpoint, data=None):
        url = f"{self.base_url}/{endpoint}"
        response = requests.put(url, headers=self.headers, json=data)
        return self._handle_response(response)

    def _delete(self, endpoint):
        url = f"{self.base_url}/{endpoint}"
        response = requests.delete(url, headers=self.headers)
        return self._handle_response(response)

    def _handle_response(self, response):
        if response.status_code == 200:
            return response.json()  # Assuming the API returns JSON
        else:
            return {'error': f'Failed with status code {response.status_code}', 'message': response.text}

    def get_entity(self, entity_id: str):
        endpoint = f"states/{entity_id}"
        return self._get(endpoint)

def get_energy_states():
    c = HomeAssistantRESTClient(BASE_URL, TOKEN)
    
    usage = c.get_entity("sensor.energy_usage")

    production = c.get_entity("sensor.energy_production")

    return usage["state"], production["state"]

usage, production = get_energy_states()

output = {"usage": usage, "production": production}

print(json.dumps(output))
