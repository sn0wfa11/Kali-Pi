# Kali-Pi

This repo contains information on how to setup Kali Linux on a Raspberry Pi computer. The goal here is to create a drop box that pentesters can drop behind firewalls to gain access to internal networks. These test both physical security and internal network security. 

The instructions and the scripts in this repo will walk you through setting up your own Kali-Pi drop box that will connect back to you automatically when plugged into power and an internet connection.

## Getting Started
First you will need to aquire a few things.
- Raspberry Pi 3 Model B 
  - [$34.99 on Amazon](https://www.amazon.com/Raspberry-Model-1-2GHz-64-bit-quad-core/dp/B01CD5VC92/ref=lp_5811495011_1_1?srs=5811495011&ie=UTF8&qid=1505689002&sr=8-1)
  - [$35 from adafruit](https://www.adafruit.com/product/3055)
- A high speed Micro-SD Card: 32 GB or 64 GB
  - I use the [Samsung Pro Select Cards from Amazon](https://www.amazon.com/Samsung-MicroSD-Adapter-MB-MF64GA-AM/dp/B06XWZBM4N/ref=sr_1_4?s=electronics&ie=UTF8&qid=1505689168&sr=1-4&keywords=samsung+pro+sd+card)
- A non-decript case
  - [This $5.99 one from Amazon works nicely](https://www.amazon.com/Enokay-Black-Case-Raspberry-Model/dp/B011RBJUOC/ref=lp_14360649011_1_2?srs=14360649011&ie=UTF8&qid=1505689475&sr=8-2)

## Initial Setup
- Start with [initial_setup.md](https://github.com/sn0wfa11/Kali-Pi/blob/master/initial_setup.md) which will walk you through getting Kali running on your raspberry pi.
- Add an encrypted patition **(Highly Recomended)**: [secure_storage.md](https://github.com/sn0wfa11/Kali-Pi/blob/master/secure_storage.md)
  - Normally all files on the SD card are readable. If someone finds the device and loads the SD card into their computer they would have access to anything you store on the SD card. Adding an encryted partition provides you with a safer place to store private files or loot from a pentest.
  - If you plan on using OpenVPN or saving an SSH private key, this is a must.

## Connect back setup

Remainder of instructions comming soon.

**Disclaimer** Do not use any of these instructions or scripts for illegal use. They are provided for education or to assist professional penetration testers in setting up drop devices. Do not place these devices on networks you do not have permission to access. I am not responsible for illegal use of these devices.
