# Pegasus Checker

<!-- Статус сборки GitHub Actions -->
![Build](https://github.com/Trytonottry/pegasus-checker/workflows/CI/badge.svg)
<!-- Лицензия -->
![License](https://img.shields.io/github/license/Trytonottry/pegasus-checker)
<!-- GitHub Pages -->
![GitHub Pages](https://img.shields.io/website?url=https://Trytonottry.github.io/pegasus-checker)
<!-- Последний коммит -->
![Last Commit](https://img.shields.io/github/last-commit/Trytonottry/pegasus-checker)


One-click helper to collect forensic artifacts from iOS/Android devices and run Mobile Verification Toolkit (MVT) checks.

## Что делает
- Создаёт аппаратные/лог-артефакты (iOS backup, Android bugreport/logcat).
- Запускает MVT анализ и складывает результаты в `reports/`.
- Вся работа локально, требуется явное согласие владельца устройства.

## Требования
- Linux / macOS (Windows возможен, но команды отличаются)
- python3, venv
- adb (android-platform-tools) — для Android
- libimobiledevice (idevicebackup2) — для iOS (альтернатива: iTunes/Finder backup)
- USB-кабель, включённый USB debugging (Android) / доверие к компьютеру (iOS)

## Быстрый старт
```bash
# подготовка
make setup
# или вручную:
./oneclick-check.sh
```
## Отчёты

Результаты сохраняются в reports/YYYYMMDD_*. MVT генерирует JSON/прочие файлы — используй их для дальнейшего анализа.

## Источники и методология

Основано на Mobile Verification Toolkit (Amnesty / MVT), рекомендациях по сбору бэкапов (libimobiledevice) и ICP/IOC списках от независимых исследователей (Citizen Lab). См. документацию MVT: https://github.com/mvt-project/mvt и https://mvt.re/

## Важные замечания

Pegasus — продвинутый «zero-click» коммерческий эксплойт: отсутствие находок не гарантирует отсутствия компрометации. Если есть серьёзные подозрения, лучше обращаться к профильным специалистам/лабораториям
