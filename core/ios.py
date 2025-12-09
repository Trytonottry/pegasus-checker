"""
Простейший iOS-процессор: создает резервную копию через idevicebackup2 (если установлен)
и вызывает MVT (при наличии).
"""
import os
import shutil
from .utils import new_report_dir

def run_scan():
report_dir = new_report_dir('ios')
print(f"[iOS] report -> {report_dir}")
if shutil.which('idevicebackup2') is None:
print('idevicebackup2 не найден. Установи libimobiledevice.')
return
backup_dir = os.path.join(report_dir, 'ios_backup')
os.makedirs(backup_dir, exist_ok=True)
cmd = f"idevicebackup2 backup {backup_dir}"
print('[iOS] Running:', cmd)
os.system(cmd)
# Если mvt установлен в PATH
if shutil.which('mvt-ios'):
out = os.path.join(report_dir, 'mvt_ios')
os.makedirs(out, exist_ok=True)
cmd2 = f"mvt-ios check-backup {backup_dir} -o {out}"
print('[iOS] Running:', cmd2)
os.system(cmd2)
else:
print('[iOS] mvt-ios not found; backup created only.')