#!/usr/bin/env bash
set -euo pipefail


ROOT="$(cd "$(dirname "$0")"; pwd)"
REPORT_DIR="$ROOT/reports/$(date +%Y%m%d_%H%M%S)"
VENV="$ROOT/.venv"
PY="$VENV/bin/python"
MVT_IOS_CMD="$VENV/bin/mvt-ios" || true
MVT_ANDROID_CMD="$VENV/bin/mvt-android" || true
ANDROIDQF_CMD="$VENV/bin/androidqf" || true


mkdir -p "$REPORT_DIR"


echo "Pegasus Checker — старт $(date)"
echo "Отчёт: $REPORT_DIR"


# create venv if missing
if [ ! -x "$PY" ]; then
echo "Создаю venv и ставлю базовые зависимости..."
python3 -m venv "$VENV"
"$VENV/bin/pip" install --upgrade pip
"$VENV/bin/pip" install --no-cache-dir fastapi uvicorn requests
# MVT install is optional — user can `pip install git+https://github.com/mvt-project/mvt.git`
fi


printf "Выберите тип устройства:\n 1) iOS\n 2) Android\n"
read -r -p "> " MODE


if [ "$MODE" = "1" ]; then
echo "iOS path"
if ! command -v idevicebackup2 >/dev/null 2>&1; then
echo "idevicebackup2 не найден. Установи libimobiledevice и повтори."
exit 1
fi
BACKUP_DIR="$REPORT_DIR/ios_backup"
mkdir -p "$BACKUP_DIR"
echo "Создаю backup..."
idevicebackup2 backup "$BACKUP_DIR"
echo "Backup saved: $BACKUP_DIR"
echo "Если установлена MVT, запусти: mvt-ios check-backup $BACKUP_DIR -o $REPORT_DIR/mvt_ios"
fi


if [ "$MODE" = "2" ]; then
echo "Android path"
if ! command -v adb >/dev/null 2>&1; then
echo "adb не найден. Установи android-platform-tools и включи USB debugging"
exit 1
fi
ADB_DIR="$REPORT_DIR/android_dump"
mkdir -p "$ADB_DIR"
adb devices
adb wait-for-device
adb shell pm list packages -f > "$ADB_DIR/packages.txt" || true
adb logcat -d > "$ADB_DIR/logcat.txt" || true
adb bugreport "$ADB_DIR/bugreport.zip" || true
echo "Собрано в $ADB_DIR. Если MVT установлен: mvt-android check-dump $ADB_DIR -o $REPORT_DIR/mvt_android"
fi


echo "Готово. Отчёт: $REPORT_DIR"