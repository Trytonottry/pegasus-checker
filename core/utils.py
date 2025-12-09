import os
import json
from datetime import datetime

def ensure_reports_dir():
d = os.environ.get('REPORTS_DIR', 'reports')
os.makedirs(d, exist_ok=True)
return d

def new_report_dir(prefix='scan'):
base = ensure_reports_dir()
name = datetime.utcnow().strftime('%Y%m%d_%H%M%S')
path = os.path.join(base, f"{prefix}_{name}")
os.makedirs(path, exist_ok=True)
return path

def read_json(path):
with open(path, 'r', encoding='utf-8') as f:
return json.load(f)

def write_json(path, data):
with open(path, 'w', encoding='utf-8') as f:
json.dump(data, f, indent=2, ensure_ascii=False)