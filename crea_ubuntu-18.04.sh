
VM=$1

#PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' '$2')

PASSWORD=paiwQrWgBoDr6

sudo virt-builder ubuntu-18.04 \
--output  /var/lib/libvirt/images/$VM.qcow2 \
--format qcow2 \
--size 10G \
--arch x86_64 \
--hostname $VM \
--root-password password:jaca \
--run-command "useradd -G sudo -m -p ${PASSWORD} -s /bin/bash toni" \
--install sudo \
--firstboot-command "dpkg-reconfigure openssh-server" \
--run-command "sed -E 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"net.ifnames=0 biosdevname=0\"/' -i /etc/default/grub" \
--run-command "grub-mkconfig -o /boot/grub/grub.cfg" \
--run-command "echo 'auto eth0' >> /etc/network/interfaces" \
--run-command "echo 'allow-hotplug eth0' >> /etc/network/interfaces" \
--run-command "echo 'iface eth0 inet dhcp' >> /etc/network/interfaces" \
--run-command "mkdir /root/.ssh && mkdir /home/toni/.ssh" \
--run-command "echo 'toni ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers" \
--run-command "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkLkmm3/vWOBNnyR8Hh82I3s/R/DuDSl2UU0Zze/0230EFJ/bkEfzA0h9UJnhuKomkvKJSv3eI5Pd9NTz3D3IAuUEkYYi16ut2dVdC48n7EUFz4P/pXXnL4KlLrKuJcSHS0gbYYcX0voRP5crW/oi2PRdgVnDeTPOAMPJxBpXJAcva2rNHOpWPsPn0m7E5SG5MNO9pTM7a+siw9saUVD/uOibsXAcIMcdi3GnhW4kL+qx0PQ/42IR/8ZPgmRwn2wTH01EQ2EnaR7pdED2k6IoC5BoOOpEF0/lqAK6BNRG9hsVhyQsdXVlO+mYUXyAnq7B1ShmX78bI9wYDX3TRCTqfjgfHImr32/QGr8YoN5BuT2LjEEzYq5sqjYhr3Y/i5UIbiV8AJBtfacSs+YZOSoo11vHFk+DidgADYE45mWMwozhbo6Gxs2PTVZvG21himmTsj9ga5/dxD2jCCnRIAVyN6Iev029S0KcxUQcyRa3RlHv0ZdAyiJQkA+dpvDbVWdM= tonicom@calculon' > /home/toni/.ssh/authorized_keys" \
--run-command "systemctl enable serial-getty@ttyS0.service" \
--run-command "systemctl start serial-getty@ttyS0.service" \
--copy-in  /home/tonicom/scripts/dhcli.service:/etc/systemd/system \
--run-command "systemctl enable dhcli && systemctl restart dhcli"

sudo virt-install \
    --name $VM \
    --vcpus 2 \
    --ram 2048 \
    --disk /home/tonicom/kvm_images/$VM.qcow2,format=qcow2 \
    --import \
    --os-variant  ubuntu18.04 \
    --network bridge:br0 \
    --graphics none \ 
    --force --debug


