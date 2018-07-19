# pivx-starterkit

To run QT GUI in mac:

```
brew cask install xquartz
brew install socat
```

Open xQuartz

```
open -a XQuartz
```

Type in xQuartz console:

```
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}') xhost + $ip
```

**In the XQuartz preferences, go to the “Security” tab and make sure you’ve got “Allow connections from network clients” ticked**

Then run docker-compose command
