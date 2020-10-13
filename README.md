This project wraps a reduced-footprint ImageJ2 to JavaScript using
[CheerpJ](https://www.leaningtech.com/pages/cheerpj.html).

VERY EARLY PROTOTYPE.

Download the latest CheerpJ compiler:
 - [Linux](https://d3415aa6bfa4.leaningtech.com/cheerpj_linux_20201013.tar.gz)
 - [MacOS](https://d3415aa6bfa4.leaningtech.com/cheerpj_macosx_20201013.dmg)
 - [Windows](https://d3415aa6bfa4.leaningtech.com/cheerpj_win_20201013.zip)

1. Use this new runtime endpoint: https://cjrtnc.leaningtech.com/20200914/loader.js
2. Make a copy of the jar (cp imagej2-cheerpj-0.1.0-SNAPSHOT-all.jar imagej2-cheerpj-0.1.0-SNAPSHOT-all.jar.bak)
3. Remove the ij.IJ class from the jar (zip -d imagej2-cheerpj-0.1.0-SNAPSHOT-all.jar ij/IJ.class)
4. Create the jar.js file, without the problematic class (`~/cheerpjf_2.1/cheerpjfy.py imagej2-cheerpj-0.1.0-SNAPSHOT-all.jar`)
5. Restore the original jar, the application expects that class file to exist (mv imagej2-cheerpj-0.1.0-SNAPSHOT-all.jar.bak imagej2-cheerpj-0.1.0-SNAPSHOT-all.jar)

Compiled ImageJ2 package: https://kth.box.com/s/e0u5abb03bhsbvd8aua20yhst310wvca

To run it, run a simple http server in the unpacked folder: `python -m http.server 9999`
