# Dynamic MOTD.
Debian, which Kali is based on, has the functionality for dynamic message of the day "MOTD" operation but it is not enabled by default. 

Fortunately, it is pretty easy to setup and has some really cool things that you can do with it especially for something like or Kali-Pi's.

## Enable Dynamic MOTD
If you already have a cool MOTD, it would be best to copy it to your `/root` directory, and you can easily recreate it here in a bit.

`cp /etc/motd /root/`

- First we need to create the new MOTD update directory.

`mkdir /etc/update-motd.d/`

- Remove the old MOTD file

`rm /etc/motd`

- And create a symbolic link to the new setup

`ln -s /var/run/motd /etc/motd`

That's it for back end work. Now we can start building our dynamic MOTD scripts!

## Background information
The new MOTD system uses bash scripts placed into `/etc/update-motd.d/`. The filenames need to start with numbers (even numbers seem to work best) and then have a lowercase description. The files are executed in order based on the number prefixes. An example would be:

```
10-header
20-uptime
```

Files need to be executable to be run by the MOTD system. If you do not want specific files executed, remove executable rights and they will be skipped.

`chmod 0755 10-header`

This new MOTD system is enabled by default in Ubuntu. You can use examples they have as a reference too.

## Install figlet and fonts
I like to have cool MOTD headers and one of the best ways to do that is to use a tool called figlet. You can install it using:

`apt install -y figlet`

To get additional fonts, just run the following:

```
mkdir -p $HOME/git
cd $HOME/git
git clone https://github.com/xero/figlet-fonts
cd figlet-fonts
mv * /use/share/figlet/
cd $HOME/git
rm -rf /figlet-fonts/
```

Now you can do really cool stuff like:

`figlet -w 120 -f "ANSI Shadow" kalipi`

Which produces:

```
██╗  ██╗ █████╗ ██╗     ██╗██████╗ ██╗
██║ ██╔╝██╔══██╗██║     ██║██╔══██╗██║
█████╔╝ ███████║██║     ██║██████╔╝██║
██╔═██╗ ██╔══██║██║     ██║██╔═══╝ ██║
██║  ██╗██║  ██║███████╗██║██║     ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝
```
