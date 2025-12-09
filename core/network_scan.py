"""
Очень простой монитор сетевого трафика: запускает tcpdump (если есть)
и/или собирает DNS-запросы, если доступен Pi-hole (API не реализован полностью).
"""
import shutil
import os
from .utils import new_report_dir




def run(duration_seconds=30):
report_dir = new_report_dir('network')
pcap = os.path.join(report_dir, 'capture.pcap')
if shutil.which('tcpdump'):
print(f"Запускаю tcpdump {duration_seconds}s -> {pcap}")
os.system(f"sudo timeout {duration_seconds} tcpdump -w {pcap} -i any")
else:
print('tcpdump не найден — пропускаю pcap.')
print('network scan done')