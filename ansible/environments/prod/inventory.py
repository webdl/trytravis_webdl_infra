#!.venv/bin/python
import os
import argparse
from python_terraform import *


def __read_outputs(tf):
    output = tf.output()
    result = {
        "app": {
            "hosts": [host.encode() for host in output['app_ids']['value']]
        },
        "db": {
            "hosts": [host.encode() for host in output['db_ids']['value']]
        },

        "_meta": {
            "hostvars": {}
        }
    }

    for i, app_id in enumerate(output['app_ids']['value']):
        result['_meta']['hostvars'][app_id.encode()] = {"ansible_host" : output['app_external_ip']['value'][i].encode()}

    for i, db_id in enumerate(output['db_ids']['value']):
        result['_meta']['hostvars'][db_id.encode()] = {"ansible_host" : output['db_external_ip']['value'][i].encode()}
    
    return result

def arg_list(tf):
    return __read_outputs(tf)

def arg_host(tf, hostname):
    return __read_outputs(tf)['_meta']['hostvars'][hostname]


if __name__ == '__main__':
    tf = Terraform(working_dir='../terraform/prod')

    parser = argparse.ArgumentParser()
    parser.add_argument('--host')
    parser.add_argument('--list', action='store_true')

    args = parser.parse_args()
    if args.list:
        print arg_list(tf)
    elif args.host:
        print arg_host(tf, args.host)
