# PiGB
Raspberry Pi GhostBox

Started in 2021, this was my attempt to create a Raspberry Pi based ghostbox using a RTLSDR dongle. I had a few requirements in mind:

* Small enough to carry around comfortably
* Completely self contained
* Output optiopns: Icecast, save to WAV, direct bluetooth (not recommended)
* Easy to use web interface to control it using the Pi's onboard wifi as an AP
* Easy way to apply SoX and FFMPEG filters to output (ex, filter out some static)

# Potential issues/Gotchas

The SDR dongles get very hot. You need to hold everything in such a way that you don't accidentally touch the metal casing on the SDR. It is normal, and expected, for the dongles to get hot. This is why I don't currently have an enclosure for everything, because I don't want to cause any sort of overheating. **Be Careful - Don't Burn Yourself**

Also, this currently only does FM, although in reality it can hop whatever the dongle supports. The linked dongle, which is a Nano, covers frequency range 25MHz - 1750MHz (but of course, the antenna matters, depending on what range). I typically use FM range and modulation, 88Mhz-108Mhz. Supporting AM is possible I imagine, but will require carrying around an upconverter and the approprate antenna. For my purposes, normal FM range or even a range that should have just static (varies by location) works well.

# Parts Used

* Raspberry Pi 4 - [Amazon.com](https://www.amazon.com/CanaKit-Raspberry-8GB-Starter-Kit/dp/B08956GVXN)
* Battery - At least 10,000mAh, you may have to also purchase the correct plug (pi 4 is USB-C, the 3 isn't) - [Amazon.com](https://www.amazon.com/gp/product/B0194WDVHI)
* Antenna - [Amazon.com](https://www.amazon.com/gp/product/B07PT76LW4)
* SDR - I used a NooELEC Nano - [Amazon.com](https://www.amazon.com/gp/product/B07XPZMDZV)
* Cable to go from SDR to antenna - [Amazon.com](https://www.amazon.com/gp/product/B00CTJN480)
