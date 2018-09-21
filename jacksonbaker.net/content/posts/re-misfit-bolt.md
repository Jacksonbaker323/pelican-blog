Title: Reverse Engineering the Misfit Bolt BTLE Protocol
Date: 2018-09-01 12:00
Modified: 2018-09-01 12:00
Category: reverse-engineering
Tags: reverse-engineering, programming
Slug: re-misfit-bolt
Authors: Jackson Baker
Summary: Reverse Engineering the Misfit Bolt BTLE Protocol

**Background**

I've lived in the Pacific Northwest for 4 years now, and like most transplants, the lack of sun in the winter has been a struggle. If you've never experienced December in the northern latitudes then let me set the scene for you: During the winter solstice the sun rises shortly before 8am and sets right after 4pm. That's barely 8 hours of sun - most of which is probably covered by clouds. I really struggle to roll out of bed in the morning when it's raining and as dark as midnight outside. 

To combat this I looked at a range of 'smart' lightbulb solutions. Ultimately I landed on the [Misfit Bolt](https://misfit.com/products/bolt) for a number of reasons:

* Uses bluetooth so there's no separate 'hub' hardware required to drive it
* Has a 'wakeup' mode that simulates a sunrise
* Has an iPhone app
* Is relatively inexpensive (Retails for $50 now, I bought it for around $30 on sale at some point)

Alright, so now you're asking "You've got a problem, you found a solution and everything's perfect. So why write this post?". Well, the hardware might suit my needs but I have some serious qualms with the quality of the software. The main reason I want this bulb is for the 'wakeup' mode. Unfortunately I'm only able to get it to work about 10% of the time. I have a feeling that this is mostly due to restrictions in iOS and not shoddy craftsmanship on the part of the developer. Either way, 6:30 rolls around with me waking up to the blare of my alarm clock rather than the soothing light of a sunrise.

**Research**

So I knew that the Bolt communicated via Bluetooth, and I had a Raspberry Pi that had a Bluetooth module. But that was about it. Over the course of an evening I got a crash-course on reverse engineering the Bluetooth Low Energy (BTLE) protocol and I'm going to share my discoveries with you in this post.

There's a great article written by the folks at Adafruit titled [Reverse Engineering a Bluetooth Low Energy Lightbulb](https://learn.adafruit.com/reverse-engineering-a-bluetooth-low-energy-light-bulb) that I used as a foundation to this exploration. This post has an amazing primer on BTLE and the tools available on Linux to interface with BTLE equipment. You should give it a quick read if you don't have any experience with BTLE as it will cover the basics.

The Adafruit team used a [custom built sniffer](https://www.adafruit.com/product/2269) that sits in between your BTLE device and controller to determine the content of the protocol. I didn't have the luxury of one of these so I moved on to plan B: using the app to send commands to the Bolt and viewing its state after each command. This was a time consuming and tedious process, but I learned a lot of core fundamentals that I can use when I create my own application to drive the Bolt.

**Investigation**

Alright, now that you've read that intro article and have a basic understanding of BTLE let's get down to brass tacks. I need a way to look at the GATT services that the Bolt exposes. Again turning to the folks at Adafruit I downloaded their [Bluefruit](https://itunes.apple.com/us/app/adafruit-bluefruit-le-connect/id830125974?mt=8) app and started poking around. 

When we first connect to the Bolt we're dropped into a screen that shows all the Services (Dark grey bar), and Characteristics 

![Bluefruit Services]({filename}/images/re-misfit-bolt/IMG_0257.JPG)

The service at the top starting with "F000FFC0" looks to be some basic information about the Firmware. Nothing too useful there. 

If we scroll down to the second service "FFF0" then things start to look a little more interesting. We see that there are a bunch of custom characteristics set, but they're all set to 0! Again, not really helpful.

![Bluefruit Services]({filename}/images/re-misfit-bolt/IMG_0258.JPG)

 At this point I switch back over to the Bolt's app and change the color from the default 'soft white' and see what happens to those characteristics. Green should be a good test!

![Green Light]({filename}/images/re-misfit-bolt/Green_Light.JPG)

Okay, now we've got some 1's where we used to have 0's in the first service, that's interesting but not too useful. 

![Bluefruit Services]({filename}/images/re-misfit-bolt/IMG_0261.JPG)

Let's have a look at the second service. Hey, that looks interesting... What was once a stream of 0's is now a bunch of hex.

![Bluefruit Services]({filename}/images/re-misfit-bolt/IMG_0263.JPG)

If we click on that then we see it translates into an ASCII value of 4 comma separated numbers! That value "50,255,0,50,,,,,,," looks like what we'd expect for a green color described in RGB values! 

![Bluefruit Services]({filename}/images/re-misfit-bolt/IMG_0262.JPG)

Let's try it again with a different color and see what happens. This time let's set it to a blue color and adjust the brightness all the way over to maximum.

![Blue light]({filename}/images/re-misfit-bolt/IMG_0266.JPG)

Look at that! FFF1 is now set to a blueish white value! of "20,20,50,100,,,,,,". Additionally, now that we've got a half brightness test and a full brightness test we can see that the 4th value controls the brightness. 

![Bluefruit Services]({filename}/images/re-misfit-bolt/IMG_0268.JPG)

After testing other features in the app I found out that the bulb will also accept a "CLTMP" code using the color temperature instead of an RGB value.  

![Bluefruit Services]({filename}/images/re-misfit-bolt/IMG_0269.JPG)

If we compare all these values against each other we also see that the number of trailing commas differs. It looks like the characteristic requires exactly 18 characters and fills the buffer with a variable number of commas. That's a requirement we'll need to remember when we start bit-bashing this protocol and bending the light to our will in Part 2!

##[Part 2!]({filename}/posts/re-misfit-bolt-pt2.md)
