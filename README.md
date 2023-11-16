

# xDSL Monitoring tool

xDSL Monitoring tool is an mobile app for realtime and background monitoring of G.DMT/ADSL/VDSL networks. It is designed to work with most popular Broadcom and Trendchip network units that support telnet or http interface. Data is displayed in detailed graphical form and can be used to perform line analysis on the go, or as standalone tool for ISPs to perform monitoring on client-end.


### Features
  - Fast and modern UI
  - Wide range of supported devices
  - Realtime stats monitoring
  - Background monitoring
  - Robust connection using raw TCP Socket implementation
  - Detailed histograms with pan and zoom
  - Exporting data to csv

  
![screenshot](https://github.com/digiboridev/xDSL-Monitoring-tool/blob/main/md/bg.jpg)

### Platform
  - Android 8+

### Installation
1. [Download](https://github.com/digiboridev/xDSL-Monitoring-tool/releases/) last version.
2. Install apk file.
3. Go to "Settings" screen and configure network unit type, ip, login and password
4. You're ready to press 'Play' button to start monitoring.

### Use-cases
- On "Monitoring" screen you can see real time stats on the go using only phone. No more laptops needed, not big batteries or cars, nor DSLAM-end person or ISPs support.
- On "Snapshots" screen you can see detailed histograms with pan and zoom. That shows precise data captured durning all monitoring period.
- Supports working in background, so you can leave phone on the client-end for a while (day,week,forever) and then analyze captured data. Really helpful for  cases that DSLAM-end is less informative like training attempts, power issues, ISPs weak sampling interval and pessimistic sync. 
- To use background logging:
   - Disable battery optimization for app ( build in andoid mechanism to suspend apps activity when screen is off, known as Doze mode )
   - Allow foreground notifications ( build in andoid mechanism to keem app in memory even if app in background )

### Supported network units
  - Broadcom 63xx based devices through telnet
    - adsl, xdslcmd, xdslctl, etc command interface support
    - second stage login ('sh' to busybox) support
    - full list of broadcomm devices [here](https://wiki.kitz.co.uk/index.php?title=BCM_routers)
  - Trendchip (aka Ralink/Mediatek) based devices through telnet
    - parsing using 'wan adsl diag + status' (less performant)
    - parsing using separate commands (more performant)
    - full list of trendchip devices [here](http://en.techinfodepot.shoutwiki.com/wiki/TrendChip)
  - HG532e (telnet lock) through http
    - parsing using http mimicking browser requests
    - stats adress 'html/status/dslinfo.asp'
    - login adress 'index/login.cgi'
  

If you want to add new device support you can simply send me a dump of your device's terminal session. It is important to have example commands and responses for successful and unsuccessful attempts to log in, request data, and respond to data in several different states such as idle, connected, initializing, etc.

### Contacts: 
  - Telegram: t.me/vladislavdev
  - Email: digiborimusik@gmail.com

### Planned features
  - SNR per tone, Bit table support
  - HLog, QLN support
  - Cloud sync for remote data sharing
  - Multi-device monitoring
  - Desktop version
