# -*- coding: utf-8 -*-
import subprocess
import RPi.GPIO as GPIO
import sys
import time

DIR = r'/home/pi/otasuke'
play_music = r'aplay ' + DIR + r'/wav/TaurusDemon.wav' + r'; exit'
send_ir = DIR + r'/remote_control/sendir'
#ir1 = DIR + r'/remote_control/cooler_on_16.dat'
ir1 = DIR + r'/remote_control/heater_on_30.dat'
ir2 = DIR + r'/remote_control/light_on.dat'

subprocess.call(send_ir + ' ' + ir1, shell=True)
p = subprocess.Popen(play_music, shell=True)

led_pin = 38
sensor_pin = 40

GPIO.setmode(GPIO.BOARD)
GPIO.setup(led_pin, GPIO.OUT)
GPIO.setup(sensor_pin, GPIO.IN)

try:
    while True:
        if(p.poll() == 0):
            GPIO.output(led_pin, 0)
            GPIO.cleanup()
            sys.exit(0)
        if(GPIO.input(sensor_pin)==1):
            subprocess.call(send_ir+ir2, shell=True)
            GPIO.output(led_pin, 0)
            GPIO.cleanup()
            #p.terminate()
            subprocess.call("kill $(ps |grep aplay |awk '{print $1}')", shell=True)
            sys.exit(1)
        if(GPIO.input(sensor_pin)==0):
            GPIO.output(led_pin, 1)
        time.sleep(0.1)
except KeyboardInterrupt:
    print('[Ctrl]+[C]でキーボード割り込みしました。')
    GPIO.cleanup()
    sys.exit(10)
