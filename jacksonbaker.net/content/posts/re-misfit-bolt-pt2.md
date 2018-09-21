Title: Reverse Engineering the Misfit Bolt BTLE Protocol Part II
Date: 2018-09-02 12:00
Modified: 2018-09-02 12:00
Category: reverse-engineering
Tags: reverse-engineering, programming
Slug: re-misfit-bolt-pt2
Authors: Jackson Baker
Summary: Reverse Engineering the Misfit Bolt BTLE Protocol Part II

Alright, now that we know what Service/Characteristic combination controls the color and brightness of the bulb lets see if we can connect directly to the bulb and send those commands without the use of the app.

First we need to find the address of the bulb. In order to do that we'll use the command hcitool to scan for all the bluetooth devices that our bluetooth radio can find. 

![HCITool]({filename}/images/re-misfit-bolt-part2/HCITool.JPG)

Up at the top we see that an address associated with the name "MFBOLT". We'll use that address to connect with the bulb.

Next we start up gatttool in interactive mode by running the command `gatttool -I`. This will let us interface with the lightbulb's services and characteristics directly.

![gattool]({filename}/images/re-misfit-bolt-part2/gattool.JPG)

The first command that we'll issue is a "connect" followed by the address that we discovered using hcitool. 

Once we've successfully connected to the bulb we're met with the "Connection successful" prompt and we can start sending commands to the bulb. If you run into trouble here remember that BTLE only allows connections from one device at a time!

![gatttool1]({filename}/images/re-misfit-bolt-part2/gatttool1.JPG)

So now that we're connected we can use the gatttool to traverse the BTLE Profile -> Service -> Characteristic hierarchy like we did with the Bluefruit app. 

First we issue the 'primary' command to show all of the services. ![gattservices]({filename}/images/re-misfit-bolt-part2/gattservices.JPG)

We can see in this list of services that there's nothing that matches our "FFF0" service exactly, but the 3rd option looks very similar. Let's see what characteristics this service has. In order to do that we'll run the command: `characteristics 0x0010 0x0046`

By running this command we're telling gatttool to list out the characteristics that fall under this service. We get the start and end of the range by looking at the 'attr handle' and 'end grp handle' values for the service.

![gattcharacteristics]({filename}/images/re-misfit-bolt-part2/gattcharacteristics.JPG)

In this list we can then start looking for the "FFF1" characteristic from our previous exploration. Again, there's nothing that matches the app exactly, but the first entry is the only one that contains "FFF1" in the UUID so let's see what that characteristic's value is. We'll do that by issuing the "char-read-hnd" command with a parameter of 0x0012 as the appropriate handle. When we do that we see that it's got a hex value that translates to "20,20,50,100,,,,,,", exactly what we'd expect for our color value! 

![readchar]({filename}/images/re-misfit-bolt-part2/readchar.JPG)

Now let's try to change that value. In order to do that we'll issue a command to that service. In order to do that we'll need the char-write-cmd command. We'll use it this way: 

`char-write-cmd 0x0012 31302c31302c39302c3130302c2c2c2c2c2c` 

This will set the value of the bulb to "10,10,90,100,,,,,,". Once we do that the bulb changes color to a soft blue glow! We can read that value back to verify that it changed. 

![readchar2]({filename}/images/re-misfit-bolt-part2/readchar2.JPG)

Now as a proof of concept we can switch over to using the gatttool command in non-interactive mode. We'll issue the following command to change the color of the bulb:

`sudo gatttool -b 54:4A:16:6E:67:2C --char-write-req -a 0x0012 --value=32302c32302c35302c3130302c2c2c2c2c2c` 

That command runs successfully and the color of the bulb changes. Now that we're able to change the color with just one command we can setup some simple shell scripts and cron jobs to simulate a sunrise.

I've made 4 separate scripts for 6:30AM, 6:45AM, 7:00AM, and then one at 9:00AM to turn the bulb off. These scripts send color temperatures of 2700, 2800, and 3000 while slowly ramping up the brightness. 

For now this is a really great proof of concept. I've been using it for the past few days and I'm generally awake around 6:50. In the future I'd like to build a small web app that can provide me with more control, but for now it's nice to wake up on my own!
