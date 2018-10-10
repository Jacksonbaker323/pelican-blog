Title: Roll your own Micropython binary
Date: 2018-10-10 12:00
Modified: 2018-10-10 12:00
Category: Programming, DIY
Tags: programming, diy
Slug: rollyourownupy
Authors: Jackson Baker
Summary: Rolling your own Micropython binary

## Why?
For larger microcontrollers with lots of memory you can simply use pip in the REPL and install anything you want. Unfortunately on the ESP8266 chips I used in my previous [post](relativeurl) there's not enough memory to run pip so you'll need to compile your own Micropython binary. This is also useful if you're producing something on a large scale and you want to flash a Microcontroller with Python, and a set of scripts ready to go. 

## How?
The first thing you need to do is get all the pre-requisites ready to go to. There are lots of very specific library requirements and SDKs so getting it setup on your own is a huge pain. Fortunately the nice folks over at Adafruit have put together a [Vagrant config](https://github.com/adafruit/esp8266-micropython-vagrant) that has everything in it you need to get started. 

Follow their instructions until you get to the "Micropython Compilation" section. This is where we'll make a slight deviation. 

Navigate into the Unix folder

We'll be using the Unix distro of Micropython to install the necessary libraries and then compile the esp8266 version

Make Micropython

Install the libraries necessary (Do the thing where you link the pip folder to the one in the Unix directory) 

Change directories to the ESP8266 folder

compile

Flash

Addendum: Adding python scripts to the binary that start automagically. 
