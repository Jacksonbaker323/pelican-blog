Title: Roll your own Micropython firmware
Date: 2018-10-10 12:00
Modified: 2019-02-13 12:00
Category: Programming, DIY
Tags: programming, diy
Slug: rollyourownupy
Authors: Jackson Baker
Summary: Build your own Micropython firmware for the ESP8266

## Why?
For larger microcontrollers with lots of memory you can simply use upip in the REPL and install anything you want. Unfortunately on the ESP8266 chips I used in my previous [post]({filename}/posts/esp8266.md) there's not enough memory to run upip so you'll need to compile your own Micropython firmware and upload it. This is also useful if you're producing something on a large scale and you want to flash a Microcontroller with Python and set of scripts ready to go. 

## How?
The first thing you need to do is get all the prerequisites ready to go to. There are lots of very specific library requirements and SDKs so getting it setup on your own is a huge pain. Fortunately the nice folks over at Adafruit have put together a [Vagrant config](https://github.com/adafruit/esp8266-micropython-vagrant) that has everything in it you need to get started. 

Follow their instructions until you get to the "Micropython Compilation" section. This is where we'll make a slight deviation. 

###Compiling for Unix
In addition to building the ESP8266 comaptible Micropython we'll be building a version that you can run locally on your computer. By doing this we'll be able to run upip or other tools to install modules, test code, and generally make development a little easier.

Once you reach the "Compile Micropython Firmware" section in the Adafruit tutorial we'll start making a few modifications.

First, instead of compiling the port in the ESP8266 directory, cd into the unix directory and compile using the same instructions. 

Once the compilation has finished there should be a "micropython" executable in the same directory. This is a Micropython interpreter that you can run locally!

###Setup iupip
Now that we have a binary that we can use locally let's setup upip so we can start installing modules. 

The easiest way to use upip in Micropython is through the REPL. Simply start the Micropython binary by running the command ``` ./micropython``` in the unix directory

Then run the following code

```python 
import upip
upip.install("packagename")
```

In my case I want to install the PicoWeb framework so I'll run 

`import picoweb` to verify that it was installed correctly.

###Link the installed modules
Now that we have the modules installed we need to make them available to the ESP8266 port of Micropython. The easiest way that I've found to do this is to simply symlink the Micropython modules using the following command:

```ln -s /home/vagrant/.micropython/lib/* /home/vagrant/micropython/ports/esp8270/modules```

###Compile the firmware
Now cd into /home/vagrant/micropython/ports/esp8266 and run the command `make`. This creates a custom version of the firmware, with your libraries in the build folder of the esp8266 directory.

Any time you install new packages make sure that you re-run the ln command above to link the new modules, then run `make clean && make` to recompile the firmware. 

###Use the custom firmware
Now you've got a binary with the modules that you installed available and ready to load onto the ESP8266. If you're using one of the Adafruit boards you can continue to follow their instructions, or if you've got a bare-bones board you can follow [my tutorial]({filename}/posts/esp8266.md) to flash the new firmware. 
