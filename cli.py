#!/usr/bin/env python3
import argparse
import os
from core import update_iocs, ios, android, network_scan, reporting


BASE_DIR = os.path.dirname(__file__)


def main():
p = argparse.ArgumentParser(prog="pegasus-checker")
sub = p.add_subparsers(dest='cmd')


sub.add_parser('update-iocs')
sub.add_parser('scan-ios')
sub.add_parser('scan-android')
sub.add_parser('monitor-network')
sub.add_parser('ui')


args = p.parse_args()
if args.cmd == 'update-iocs':
update_iocs.update_all()
elif args.cmd == 'scan-ios':
ios.run_scan()
elif args.cmd == 'scan-android':
android.run_scan()
elif args.cmd == 'monitor-network':
network_scan.run()
elif args.cmd == 'ui':
os.execvp('python3', ['python3', 'webui/server.py'])
else:
p.print_help()


if __name__ == '__main__':
main()