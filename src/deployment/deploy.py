#!/usr/bin/env python3

import json
import argparse

SERVICES_FILE = 'services.json'

args = None
all_services = set()


def get_args():
    global args
    parser = argparse.ArgumentParser(description='Mega Project service deployment script')
    parser.add_argument('services', help='User specified services', nargs='+')
    parser.add_argument('-x',
                        '--exclude-mode',
                        dest='exclude_mode',
                        action='store_true',
                        help='If set, all service EXCEPT the ones you specify will be deployed')
    args = parser.parse_args()


def get_all_services():
    with open('SERVICES_FILE') as file_data:
        all_services = json.load(file_data)


def get_deployment_list():
    user_specified_services = get_user_specified_services()
    if args.exclude:
        return all_services - user_specified_services
    else:
        return user_specified_services


def get_user_specified_services():
    pass


def deploy_service():
    pass


def main():
    get_args()
    # get_all_services()
    # deployment_set = get_deployment_list()
    # for service in deployment_set:
    #     deploy_service(service)
    print('hello')
    print(args.services)
    if args.exclude_mode is None:
        print('IT IS NOT SETTTT')
    else:
        print(args.exclude_mode)


if __name__ == '__main__':
    main()
