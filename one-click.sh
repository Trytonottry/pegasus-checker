#!/usr/bin/env bash
set -euo pipefail

# One-click forensic helper: collects artifacts from iOS/Android and runs MVT checks.
# WARNING: use only on devices you own or have explicit consent to analyze.

ROOT="$(cd "$(dirname "$0")"; pwd)"
REPORT_DIR="$ROOT/reports/$(date +%Y%m%d_%H%M%S)"
VENV="$ROOT/.venv"
PY="$VENV/bin/python"
MVT_IOS_CMD="$VENV/bin/mvt-ios"
ANDROIDQF_CMD="$VENV/bin/androidqf" || true

mkdir -p "$REPORT_DIR"

echo "=== Pegasus Checker — старт $(date) ==="
echo "Отчёт будет в: $REPORT_DIR"
echo

# ensure python venv & mvt installed
if [ ! -x "$PY" ]; then
  echo "Создаю venv и ставлю зависимости..."
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install --upgrade pip
  "$VENV/bin/pip" install git+https://github.com/mvt-project/mvt.git
  "$VENV/bin/pip" install git+https://github.com/mvt-project/androidqf.git || true
fi

# Ask user: target device type (iOS/Android)
echo "Выберите тип устройства для проверки:"
echo "  1) iOS (iPhone/iPad)"
echo "  2) Android"
read -r -p "Номер (1/2) > " MODE

if [ "$MODE" = "1" ]; then
  echo "=== iOS path ==="
  # check libimobiledevice
  if ! command -v idevicebackup2 >/dev/null 2>&1; then
    echo "idevicebackup2 не найден. Установи libimobiledevice (Linux: apt/brew) и повтори."
    exit 1
  fi

  BACKUP_DIR="$REPORT_DIR/ios_backup"
  mkdir -p "$BACKUP_DIR"

  echo "Создаём iTunes-совместимый бэкап через idevicebackup2..."
  echo "Если хочешь зашифровать бэкап (рекомендуется), введи пароль на устройстве."
  idevicebackup2 backup "$BACKUP_DIR"
  echo "Бэкап завершён: $BACKUP_DIR"

  # Run mvt-ios check-backup
  echo "Запускаем mvt-ios check-backup..."
  # Default IOC path: если нет — mvt скачает/использует встроенные?
  # Лучше, если есть локальные IOCs, положить их рядом; иначе MVT может работать с обновлённым списком.
  "$MVT_IOS_CMD" check-backup "$BACKUP_DIR" -o "$REPORT_DIR/mvt_ios" || echo "mvt-ios завершился с кодом !=0 (см выше)."

  echo "Результаты mvt-ios в $REPORT_DIR/mvt_ios"
fi

if [ "$MODE" = "2" ]; then
  echo "=== Android path ==="
  # check adb
  if ! command -v adb >/dev/null 2>&1; then
    echo "adb не найден. Установи android-platform-tools и включи USB-debugging на телефоне."
    exit 1
  fi

  ADB_DIR="$REPORT_DIR/android_dump"
  mkdir -p "$ADB_DIR"

  echo "Собираем список пакетов, logcat и bugreport..."
  adb devices
  adb wait-for-device

  echo "Сохраняем список установленных пакетов..."
  adb shell pm list packages -f > "$ADB_DIR/packages.txt" || true

  echo "Собираем logcat (10s) — можно увеличить при необходимости..."
  adb logcat -d > "$ADB_DIR/logcat.txt" || true

  echo "Снимаем bugreport (может занять минуту)..."
  adb bugreport "$ADB_DIR/bugreport.zip" || true

  # Try androidqf if available
  if command -v "$ANDROIDQF_CMD" >/dev/null 2>&1 || [ -f "$VENV/bin/androidqf" ]; then
    echo "Запускаем androidqf quick forensics..."
    "$VENV/bin/androidqf" dump "$ADB_DIR" || echo "androidqf завершился с ошибкой (но остальное собрано)."
  else
    echo "androidqf не найден в venv; собранные артефакты лежат в $ADB_DIR"
  fi

  echo "Запускаем mvt-android check (по собранным данным)..."
  # mvt-android имеет разные подкоманды — ниже пример запуска check on collected dir (подкорректировать по версии mvt)
  "$VENV/bin/mvt-android" check-dump "$ADB_DIR" -o "$REPORT_DIR/mvt_android" || echo "mvt-android вернул !=0 (см выше)."

  echo "Результаты mvt-android в $REPORT_DIR/mvt_android"
fi

echo
echo "=== Завершено. Результаты: $REPORT_DIR ==="
echo "Проверь JSON/HTML в папке отчёта. Для глубокой диагностики используй mvt вручную и актуальные IOC списки (Citizen Lab / Amnesty)."
