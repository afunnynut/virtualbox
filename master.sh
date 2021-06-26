#!/bin/bash
whoami=$USER
i=0
echo "Please enter the number of VMs"
read i;
while [[ "$i" -gt 0 ]]; do $((i--));
# Download ubuntu.iso
if [ ! -f /Users/`echo $USER`/Desktop/ubuntu-server.iso ]; then
    wget https://releases.ubuntu.com/20.04.2/ubuntu-20.04.2-live-server-amd64.iso -O /Users/`echo $USER`/Desktop/ubuntu-server.iso
fi

#Create VM
VBoxManage createvm --name VM$i --ostype "Ubuntu_64" --register --basefolder /Users/`echo $USER`/VirtualBox\ VMs/ 
#Set memory and network
VBoxManage modifyvm VM$i --ioapic on
VBoxManage modifyvm VM$i --memory 1024 --vram 128
VBoxManage modifyvm VM$i --nic1 nat
#Create Disk and connect Ubuntu Iso
VBoxManage createhd --filename /Users/`echo $USER`/VirtualBox\ VMs/VM$i/VM$i_DISK.vdi --size 80000 --format VDI
VBoxManage storagectl VM$i --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach VM$i --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  /Users/`echo $USER`/VirtualBox\ VMs/VM$i/VM$i_DISK.vdi
VBoxManage storagectl VM$i --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach VM$i --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium /Users/`echo $USER`/Desktop/ubuntu-server.iso
VBoxManage modifyvm VM$i --boot1 dvd --boot2 disk --boot3 none --boot4 none

#Enable RDP
VBoxManage modifyvm VM$i --vrde on
VBoxManage modifyvm VM$i --vrdemulticon on --vrdeport 10001

#Start the VM
VBoxManage startvm VM$i --type headless
done
