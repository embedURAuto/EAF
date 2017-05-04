*** Settings ***
Library       Telnet
Variables     C:\Users\chaitanyap\PycharmProjects\EAF\configs\og1600_60_bootfile_param.yaml
Variables     C:\Users\chaitanyap\PycharmProjects\EAF\configs\terminal_server.yaml

#Test Setup    clear terminal server lines
#Test Teardown    exit suite

*** Test Cases ***
clear terminal server lines
   Open Connection    ${terminal_server}
   Read Until    Password:
   write   ${terminal_server_pass}
   Read Until    >
   write   en
   Read Until    Password:
   write   ${terminal_server_pass}
   Read Until    \#
   write    clear line ${60_arm_port}
   Read Until    [confirm]
   write    y
   Read Until    \#
   write    clear line ${60_atom_port}
   Read Until    [confirm]
   write    y
   Read Until    \#
   write   exit
   log to console   "Terminal Server lines are cleared"


soft_gre_validation
   [Setup]    telnet to arm
   write  system
   sleep  5
   Read Until    >
   write  gre
   ${gre}   Read Until    >
   should contain   ${gre}    WAN_ENABLE=1
   should contain   ${gre}    WAN_CONTROLLER_FQDN=192.168.43.100
   should contain   ${gre}    WAN_CONTROLLER_2nd_ADDR=192.168.43.234
   sleep  5
   [Teardown]    logout from arm
   sleep   10

ssid_validation
    [Setup]    telnet to atom
    write   quit
    Read Until     \#
    # ath2
    write   iwconfig
    sleep    10
    ${ssid_athX}    Read Until    \#
    should contain   ${ssid_athX}    ${bootfile_ssid_ath2}
    should contain   ${ssid_athX}    ${bootfile_ssid_ath3}
    should contain   ${ssid_athX}    ${bootfile_ssid_ath4}
    should contain   ${ssid_athX}    ${bootfile_ssid_ath5}
    should contain   ${ssid_athX}    ${bootfile_ssid_ath6}
    should contain   ${ssid_athX}    ${bootfile_ssid_ath10}
    should contain   ${ssid_athX}    ${bootfile_ssid_ath11}
    should contain   ${ssid_athX}    ${bootfile_ssid_ath12}
    should contain   ${ssid_athX}    ${bootfile_ssid_ath13}
    should contain   ${ssid_athX}    ${bootfile_ssid_ath14}
    [Teardown]    logout from atom
    sleep  10

acs_validation
    [Setup]    telnet to atom
    write   quit
    Read Until     \#
    # ath2
    write   cfg -s | grep AP_ACS_ALLOWED_LIST
    sleep    10
    ${acs}    Read Until    \#
    should contain   ${acs}    ${bootfile_acs24}
    should contain   ${acs}    ${bootfile_acs05}
    [Teardown]    logout from atom
    sleep  10

beacon_int_validation
    [Setup]    telnet to atom
    write   quit
    Read Until     \#
    # ath2
    write   cfg -s | grep BEACON_INT
    sleep    10
    ${beacon_int}    Read Until    \#
    should contain   ${beacon_int}    ${bootfile_beacon_int_ath2}
    should contain   ${beacon_int}    ${bootfile_beacon_int_ath3}
    should contain   ${beacon_int}    ${bootfile_beacon_int_ath4}
    should contain   ${beacon_int}    ${bootfile_beacon_int_ath5}
    should contain   ${beacon_int}    ${bootfile_beacon_int_ath6}
    should contain   ${beacon_int}    ${bootfile_beacon_int_ath10}
    should contain   ${beacon_int}    ${bootfile_beacon_int_ath11}
    should contain   ${beacon_int}    ${bootfile_beacon_int_ath12}
    should contain   ${beacon_int}    ${bootfile_beacon_int_ath13}
    should contain   ${beacon_int}    ${bootfile_beacon_int_ath14}
    [Teardown]    logout from atom
    sleep  10

*** Keywords ***
telnet to arm
   Open Connection    ${terminal_server_ip}      port=${og1600_60_arm_port}
   sleep   2
   write Bare    \r\n
   sleep  2
   Read Until    Enter password>
   Write    ${og1600_60_arm_login}
   Read Until    >
   Write    stat
   ${status}   Read Until    >
   should contain   ${status}  OPERATIONAL
   sleep  5
   log to console   "Login to ARM Successful..."


telnet to atom
   Open Connection    ${terminal_server_ip}      port=${og1600_60_atom_port}
   sleep   5
   write Bare    \r\n
   sleep  5
   Read Until    Enter password>
   Write    ${og1600_60_atom_login}
   Read Until    >
   Write    stat
   ${status}   Read Until    >
   should contain   ${status}  IntelCE
   sleep  5
   log to console   "Login to ATOM Successful..."


logout from arm
   write    !logout
   log to console    "ARM Logout..."
   sleep  5
   Close Connection

logout from atom
    write    exit
    write    !logout
    log to console    "ATOM Logout..."
    sleep   5
    Close Connection