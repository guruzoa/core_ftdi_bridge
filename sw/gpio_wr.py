#!/usr/bin/env python
import sys
import argparse

from bus_interface import *

##################################################################
# Main
##################################################################
def main(argv):
    
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', dest='type',   default='ftdi',                     help='Device type (ftdi_async|ftdi)')
    parser.add_argument('-d', dest='device', default='210276AD4C70',             help='Device ID serial.iface_id (e.g. FT3XO4LY.1 or FT3XO4LY.0)')
    parser.add_argument('-v', dest='value',  required=True,                   help='Value to write')
    parser.add_argument('-q', dest='quiet',  action='store_true', default=False, help='Quiet mode - set exit code to read value')
    args = parser.parse_args()

    bus_if = BusInterface(args.type, args.device)

    value  = int(args.value, 0)
    bus_if.write_gpio(value)

    value  = bus_if.read_gpio()
    if not args.quiet:
        print("0x%08x (%d)" % (value, value))
    else:
        sys.exit(value)

if __name__ == "__main__":
   main(sys.argv[1:])
