

# xDSL Monitoring tool

xDSL Monitoring tool is an android app for collect line stats of ADSL modem in realtime and background.
It works with DSL modems using telnet or http interface. Data is displayed in graphical form and can be used to identify problems with dsl lines. 
This is a helpful tool that makes network staff job more easier and dsl ISPs happier.



# Features

  - Realtime stats monitoring
  - Background logging
  - Plotting precise graphs
  - Exporting data to csv

  
  
![screenshot](https://github.com/digiborimusik/xDSL-Monitoring-tool/blob/main/md/bg.jpg)

# Platform
  - Android 8+

# Installation
[Download](https://github.com/digiborimusik/xDSL-Monitoring-tool/releases/) last version.

Install apk file.

Grant persmission for working in background (According to your os shell).

# Supported network units
  - Generic Broadcom BCM63xx based via telnet
  - Generic Trendchip(Ralink, MTK) based via telnet
  - Huawei hg532e via web
  - TP-Link w8901n via telnet
  - ZTE H108n v1 via telnet
  - DLink 2640u via telnet
  - Tenda d301 via telnet
  - ZyXEL 660HW via telnet
  
If you want to add new device support or fix existing verion, contact me.
digiborimusik@gmail.com

Alternatively, you can simply send me a dump of your device's terminal session. It is important to have example commands and responses for successful and unsuccessful attempts to log in, request data, and respond to data in several different states such as idle, connected, initializing, etc.

# Planned features
  - SNR per tone, Bitloading, Bitswap support
  - HLog, QLN support
  - Cloud sync for remote data sharing
  - Desktop version
