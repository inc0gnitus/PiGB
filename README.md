# PiGB
Raspberry Pi GhostBox

_The first ghost box was created by Frank Sumption, who died in 2014, and was really made to talk to aliens._

Started in 2021, this was my attempt to create a Raspberry Pi based ghostbox using a RTLSDR dongle. I had a few requirements in mind:

* Small enough to carry around comfortably
* Output optiopns: Icecast, save to WAV, onboard audio jack
* Easy to use web interface to control it using the Pi's onboard wifi as an AP
* Easy way to apply SoX and FFMPEG filters to output (ex, filter out some static)

# Potential issues/Gotchas

## Security

This isn't built to be secure. The web interface especially is very basic with no security built in yet. 

## Beware Hot Dongles!

The SDR dongles get very hot. You need to hold everything in such a way that you don't accidentally touch the metal casing on the SDR. It is normal, and expected, for the dongles to get hot. This is why I don't currently have an enclosure for everything, because I don't want to cause any sort of overheating. **Be Careful - Don't Burn Yourself**

## No AM currently 

Also, this currently only does FM, although in reality it can hop whatever the dongle supports. The linked dongle, which is a Nano, covers frequency range 25MHz - 1750MHz (but of course, the antenna matters, depending on what range). I typically use FM range and modulation, 88Mhz-108Mhz. Supporting AM is possible I imagine, but will require carrying around an upconverter (there is a nano version: [HamItUp Nano](https://www.amazon.com/Ham-Up-Nano-Upconverter-Accessories/dp/B084KL1MXM)) and the approprate antenna. For my purposes, normal FM range or even a range that should have just static (varies by location) works well.

## Really, really bad web interface (no, I mean really)

The web interface is the most user unfriendly pile crap that ever existed, especially for a web interface intended for a phone web browser. It's on my todo list to fix. I'm serious tho, it's pretty bad. At the moment I have 2 web interfaces; one that uses SoX for audio processing and one that uses ffmpeg.

# Case (or lack thereof)

Right now I use the Pi4 case that came with the Canakit linked below, with the Nano SDR plugged into one of the USB ports and the antenna and battery attached with some velcro. The SDR is designed to get hot as it's used, so I am not sure how that can be put into a case that's easy to carry. It basically fits in the palm of my hand as it is now, but I've also considered adding some sensors (temp, etc), and there's no place to mount them currently. Here's a couple links showing how mine is put together. I like this because it goes in the palm of my hand and my hand can touch the antenna (or not, depending on mood) and still keep away from the hot SDR case.

I do have a fan installed in this case, but it's unplugged and temps seem fine after an hour of usage. I'm concerned about the SDR picking up noise from the fan.

Not pictured is the USB to USB-C power cable.

![PiGB](images/IMG_1532.jpeg)
![PiGB](images/IMG_1531.jpeg)

# Parts Used

* Raspberry Pi 4 - [Amazon.com](https://www.amazon.com/CanaKit-Raspberry-8GB-Starter-Kit/dp/B08956GVXN)
	* Raspberry PI 3 and below is not recommended because they do not have a USB 3.0 port which could lead to drops when using the SDR
	* A Raspberry Pi 5 can be used but has different [power requirements](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#typical-power-requirements) so keep that in mind when buying a battery.
* Battery - At least 10,000mA - [Amazon.com](https://www.amazon.com/gp/product/B0194WDVHI)
* USB to USB-C power cable if the battery you buy doesnt have o e
* Antenna - [Amazon.com](https://www.amazon.com/gp/product/B07PT76LW4)
* SDR - I used a NooELEC Nano - [Amazon.com](https://a.co/d/6xDnP3k)
* Cable to go from SDR to antenna - [Amazon.com](https://www.amazon.com/gp/product/B00CTJN480)
* SD card (if you don't buy the kit, the bigger the card, the more recordings you can make)

You can use whatever battery you want, as long as it plugs into the USB-C power connector on the Pi. You can also use a larger SDR, not the Nano, but for me it makes it harder to carry around without a proper case. The antenna could be just a wire. 

# Install

There is a simple install, which starts rtl_gb on boot and doesn't allow you to make any changes easily, and a full install, which includes instructions on setting up the Pi as a wifi access point, installing a web browser and web interface and setting up icecast for audio streaming.

Either way, start with [Simple Install](INSTALL-Simple.md)
  
# How I Use It

YMMV, but for me when I reach a location I want to use the PiGB in, I plug in the battery and give it a minute to boot. Then on my phone, I connect to a wireless network named PiGB. Once joined, you can pull up the web interface to control the ghostbox. Typically I use "Stream to Icecast", which allows me to use VLC on my phone to play the audio stream and from there I can pair a bluetooth speaker or earbuds to my phone if I want privacy. I usually just use the phone speaker. Icecast is a nice option because multiple people can connect to the Pi's wifi AP and then stream from Icecast on their own device (with their own speaker/earbuds). 

While walking through the woods,  my wife will usually carry the Pi and I'll control/output on my phone. I've noticed I can get a good 20 feet away and not lose the wireless connection. The battery linked above has been used many times, and an hour long session doesn't usually take 25% of the battery. I've never gone long enough to wipe out the battery. 

It can absolutely be used plugged into power, have a bigger or different antenna or a million other tweaks. I tend to only plug it into power (and ethernet) during development and testing.

# To Do

* I'd like to write my own rtl_gb, rather then it being a hack of rtl_fm. There is a learning curve there that I haven't had time to commit to.

* Write a better web interface.

* Add the ability to save/load custom settings (frequency, hop delay, etc). Sort of like bookmarks.

* Save to file with AI transcription - Would be interesting to see what AI "hears" versus what we hear.

* Add a real time clock module - The date and time will be wrong unless you plug it in so it has internet access to update date and time. Should be easily solved by adding a cheap RTC module.

# Shout Outs

* My wife who has helped me test this many times. I love her more!

* Greg and Dana Newkirk, Karl, Conner and Tyler - Hellier was a huge part of why I wanted to build this. Proud Museum member. Check out [The Unbinding](https://youtu.be/DzCo7UWDUjE?si=s8udfcyqimweGCxO)!

* Skedoozy - Talk about weird synchronicities! Always great meeting a fellow weirdo and Museum member "out in the wild". Check out [Arcane Archeology](https://www.arcanearcheology.com/)!
