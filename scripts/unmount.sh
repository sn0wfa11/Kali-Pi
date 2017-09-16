#!/bin/bash

umount /dev/mapper/sec_store
cryptsetup luksClose /dev/mapper/sec_store
