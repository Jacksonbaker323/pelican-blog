Title: Roll your own Micropython binary
Date: 2018-10-10 12:00
Modified: 2018-10-10 12:00
Category: Programming, DIY
Tags: programming, diy
Slug: rollyourownupy
Authors: Jackson Baker
Summary: Rolling your own Micropython binary

## Why?
For larger microcontrollers with lots of memory you can simply use pip in the REPL and install anything you want. Unfortunately on the ESP8266 chips I used in my previous [post]({filename}/posts/esp8266.md) there's not enough memory to run pip so you'll need to compile your own Micropython binary. This is also useful if you're producing something on a large scale and you want to flash a Microcontroller with Python and set of scripts ready to go. 

## How?
The first thing you need to do is get all the pre-requisites ready to go to. There are lots of very specific library requirements and SDKs so getting it setup on your own is a huge pain. Fortunately the nice folks over at Adafruit have put together a [Vagrant config](https://github.com/adafruit/esp8266-micropython-vagrant) that has everything in it you need to get started. 

Follow their instructions until you get to the "Micropython Compilation" section. This is where we'll make a slight deviation. 

###Compiling for Unix
In addition to building the ESP8266 comaptible Micropython we'll be building a version that you can run locally on your computer. By doing this we'll be able to run pip or other tools to install modules, test code, and generally make development a little easier.

Once you reach the "Compile Micropython Firmware" section in the Adafruit tutorial we'll start making a few modifications.

First, instead of compiling the port in the ESP8266 directory, cd into the unix directory and compile using the same instructions. 

Once the compilation has finished there should be a "micropython" executable in the same directory. This is a Micropython interpreter that you can run locally!

###Setup pip
Now that we have a binary that we can use locally let's setup pip so we can start installing modules. 

The easiest way to use pip in Micropython is through the REPL. Simply start the Micropython binary by running the command ``` ./micropython``` in the unix directory

Then run the following code 

``` import upip
upip.install("packagename")
```

In my case I want to install the PicoWeb framework so I'll run 

```import picoweb``` to verify that it was installed correctly.

Link /.micropython/lib to the modules directory of the ESP8266 folder
cd into the ESP8266 modules folder and run ln -s /home/vagrant/.micropython/lib/* .

Make sure to run this command and make clean && make any time you've installed new modules. This will load the new modules and rebuild the firmware. 

Now at this point we have a working unix binary with the tools and modules that we need pre-installed. Unfortunately we can't upload that to the ESP8266 board so we'll need to go back to the Adafruit instructions and compile the ESP8266 compatible firmware. 

Now you've got a binary with the modules that you installed available and ready to load onto the ESP8266. If you're using one of the Adafruit boards you can continue to follow their instructions, or if you've got a bare-bones board you can follow my instructions to flash the new firmware. 
