#!/bin/sh

echo '---------- Disattivazione Slice 3 ----------'

# Disabilita le porte di s4 che sono collegate a h5 e h6 utilizzando ifconfig
sudo ifconfig s4-eth1 down  # Disabilita la porta collegata a h5
sudo ifconfig s4-eth2 down  # Disabilita la porta collegata a h6

# Blocca il traffico tra s4 e s1 per isolare la slice 3 dal resto della rete
sudo ovs-ofctl add-flow s4 priority=65500,in_port=s4-eth3,actions=drop
sudo ovs-ofctl add-flow s1 priority=65500,in_port=s1-eth3,actions=drop

# Blocca ulteriormente il traffico in entrata/uscita su s4-eth1 e s4-eth2
sudo ovs-ofctl add-flow s4 priority=65535,in_port=s4-eth1,actions=drop
sudo ovs-ofctl add-flow s4 priority=65535,in_port=s4-eth2,actions=drop


echo 'Slice 3 disattivata.'
