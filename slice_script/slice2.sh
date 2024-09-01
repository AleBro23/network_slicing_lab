#!/bin/sh

echo '---------- Disattivazione Slice 2 ----------'

# Disabilita le porte di s3 che sono collegate a h3 e h4 utilizzando ifconfig
sudo ifconfig s3-eth1 down  # Disabilita la porta collegata a h3
sudo ifconfig s3-eth2 down  # Disabilita la porta collegata a h4

# Blocca il traffico tra s3 e s1 per isolare la slice 2 dal resto della rete
sudo ovs-ofctl add-flow s3 priority=65500,in_port=s3-eth3,actions=drop
sudo ovs-ofctl add-flow s1 priority=65500,in_port=s1-eth2,actions=drop

# Blocca ulteriormente il traffico in entrata/uscita su s3-eth1 e s3-eth2
sudo ovs-ofctl add-flow s3 priority=65535,in_port=s3-eth1,actions=drop
sudo ovs-ofctl add-flow s3 priority=65535,in_port=s3-eth2,actions=drop


echo 'Slice 2 disattivata.'
