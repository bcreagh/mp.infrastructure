#!/usr/bin/env python3

import os
import json
import argparse
import subprocess

SERVICES_FILE = 'services.json'

args = None
all_services = []
default_working_directory = ''


def set_working_directory():
    global default_working_directory
    abspath = os.path.abspath(__file__)
    default_working_directory = os.path.dirname(abspath)
    os.chdir(default_working_directory)


def get_args():
    global args
    parser = argparse.ArgumentParser(description='Mega Project service deployment script')
    parser.add_argument('services', help='User specified services', nargs='*')
    parser.add_argument('-x',
                        '--exclude-mode',
                        dest='exclude_mode',
                        action='store_true',
                        help='If set, all service EXCEPT the ones you specify will be deployed')
    parser.add_argument('-b',
                        '--base-directory',
                        dest='base_directory',
                        default='~/mega-project',
                        help='If set, all service EXCEPT the ones you specify will be deployed')
    args = parser.parse_args()


def get_all_services():
    global all_services
    with open(SERVICES_FILE) as file_data:
        all_services = json.load(file_data)


def get_deployment_list():
    deployment_list = []
    user_specified_services = get_user_specified_services()
    if not user_specified_services:
        deployment_list = all_services
    elif args.exclude_mode:
        for service in all_services:
            if service not in user_specified_services:
                deployment_list.append(service)
    else:
        deployment_list = user_specified_services
    return deployment_list


def get_user_specified_services():
    user_specified_services = []
    for user_service in args.services:
        service_found = False
        for service in all_services:
            if service['name'] == user_service:
                user_specified_services.append(service)
                service_found = True
                break
        if not service_found:
            raise IndexError('The service "{}" is not registered as an MP service!'.format(user_service))
    return user_specified_services


def deploy_service(service):
    path_to_service = os.path.join(args.base_directory, service['location'])
    if not os.path.isdir(path_to_service):
        git_clone_service(service)
    os.chdir(path_to_service)
    deploy_script = os.path.join(path_to_service, 'scripts', 'lifecycle', 'deploy')
    subprocess.run([deploy_script])
    os.chdir(default_working_directory)


def git_clone_service(service):
    os.chdir(args.base_directory)
    subprocess.run(['git', 'clone', service['git_repo']])
    os.chdir(default_working_directory)


def main():
    set_working_directory()
    get_args()
    get_all_services()
    deployment_list = get_deployment_list()
    for service in deployment_list:
        deploy_service(service)


if __name__ == '__main__':
    main()
