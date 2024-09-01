#!/bin/sh

echo '---------- Disattivazione Slice 1 ----------'

# Disabilita le porte di s2 che sono collegate a h1 e h2 utilizzando ifconfig
sudo ifconfig s2-eth1 down  # Disabilita la porta collegata a h1
sudo ifconfig s2-eth2 down  # Disabilita la porta collegata a h2

# Blocca il traffico tra s2 e s1 per isolare la slice 1 dal resto della rete
sudo ovs-ofctl add-flow s2 priority=65500,in_port=s2-eth3,actions=drop
sudo ovs-ofctl add-flow s1 priority=65500,in_port=s1-eth1,actions=drop

# Blocca ulteriormente il traffico in entrata/uscita su s2-eth1 e s2-eth2
sudo ovs-ofctl add-flow s2 priority=65535,in_port=s2-eth1,actions=drop
sudo ovs-ofctl add-flow s2 priority=65535,in_port=s2-eth2,actions=drop


echo 'Slice 1 disattivata.'