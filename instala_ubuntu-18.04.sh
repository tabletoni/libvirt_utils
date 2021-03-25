sudo virt-install \
    --name $1 \
    --vcpus 2 \
    --ram 2048 \
    --disk /home/tonicom/kvm_images/$1.qcow2,format=qcow2 \
    --nographics \
    --import \
    --os-variant ubuntu18.04 \
    --network bridge:br0
    ##--network type=direct,source=team0,source_mode=bridge  
