# Download and Installation #

  * Install the [GAP](http://www.gap-system.org) system, version 4.5 or higher.
    * **Under Linux**: run **"rsync --port=8731 -azv rsync.gap-system.org::gap4r5/gapsync/gapsync ."** followed by **"./gapsync"** (see **http://www.math.rwth-aachen.de/~Frank.Luebeck/gap/rsync/index.html** for details). You may need admin rights to perform this step.
    * **Under Windows**: download the Windows installer under **http://www.gap-system.org/pub/gap/windowsinstaller/gap4r7p5_2014_05_24-20_02.exe** and follow the instructions given under **http://www.gap-system.org/ukrgap/wininst/**.
    * **Under Mac OS X (or Linux)**: follow the instructions given under **http://gap-system.github.io/bob/**
  * (Optional) Download the current **[simpcomp](http://code.google.com/p/simpcomp/downloads/list)** Version (This step is only required if you want to use features of simpcomp which are not yet included in the official release). Copy folder **GAPROOT/pkg/simpcomp** to **GAPROOT/pkg/simpcomp-old** and unpack the archive to the directory **GAPROOT/pkg/** (default for **GAPROOT** is **/usr/local/lib/gap4r5**).
  * (Optional) Run **"chmod +x configure; ./configure; make; make install; make clean"** (This step is only required if you want to use **SCReduceComplexFast()**). You may need admin rights to perform this step.
  * From within **GAP**, load **simpcomp** using the following command which should return **true**.

<pre>
gap> SCLoadPackage("simpcomp");<br>
Loading simpcomp 2.0.0<br>
by F.Effenberger and J.Spreer<br>
https://code.google.com/p/simpcomp/<br>
true<br>
</pre>

  * Run **"SCRunTest();"** for a quick self test of **simpcomp** that assures the package works correctly. The output of the test function should look like this (the number printed after **GAP4stones** is a performance measure of your system and thus may differ from computer to computer):

<pre>
gap> SCRunTest();<br>
+ simpcomp package test<br>
+ GAP4stones: 28579<br>
true<br>
</pre>

  * If you want **simpcomp** to automatically load upon **GAP** startup, either set the variable **Autoload:=true** in **GAPROOT/pkg/simpcomp/PackageInfo.g** (in line ~106) or add the command **LoadPackage("simpcomp");** to your**~/.gaprc**.