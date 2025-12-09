import os
import hashlib
import urllib.request


IOC_SOURCES = {
"citizenlab": "https://raw.githubusercontent.com/CitizenLab/pegasus-indicators/main/iocs.json",
"mvt": "https://raw.githubusercontent.com/mvt-project/mvt/master/iocs/stix/stix2/iocs.json",
}


CACHE_DIR = os.environ.get('IOC_CACHE', 'iocs/cache')

def _sha256(data: bytes) -> str:
return hashlib.sha256(data).hexdigest()

def download_ioc(name: str, url: str) -> None:
os.makedirs(CACHE_DIR, exist_ok=True)
target = os.path.join(CACHE_DIR, f"{name}.json")
print(f"[+] Downloading {name} -> {target}")
try:
data = urllib.request.urlopen(url, timeout=30).read()
with open(target, 'wb') as f:
f.write(data)
print(f" saved ({_sha256(data)[:16]}...)")
except Exception as e:
print(f" failed: {e}")

def update_all():
for name, url in IOC_SOURCES.items():
download_ioc(name, url)

if __name__ == '__main__':
update_all()
