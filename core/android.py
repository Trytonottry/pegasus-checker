"""
Android quick-collector: использует adb, собирает packages, logcat, bugreport и
пытается вызвать androidqf / mvt-android, если присутствуют.
"""
import os
import shutil
from .utils import new_report_dir




def run_scan():
report_dir = new_report_dir('android')
print(f"[Android] report -> {report_dir}")
if shutil.which('adb') is None:
print('adb не найден. Установи android-platform-tools.')
return
adb_dir = os.path.join(report_dir, 'adb_dump')
os.makedirs(adb_dir, exist_ok=True)
os.system('adb devices')
os.system('adb wait-for-device')
os.system(f"adb shell pm list packages -f > {os.path.join(adb_dir, 'packages.txt')}")
os.system(f"adb logcat -d > {os.path.join(adb_dir, 'logcat.txt')}")
bug = os.path.join(adb_dir, 'bugreport.zip')
os.system(f"adb bugreport {bug} || true")
if shutil.which('androidqf'):
os.system(f"androidqf dump {adb_dir} || true")
if shutil.which('mvt-android'):
out = os.path.join(report_dir, 'mvt_android')
os.makedirs(out, exist_ok=True)
os.system(f"mvt-android check-dump {adb_dir} -o {out} || true")
print('[Android] Done')