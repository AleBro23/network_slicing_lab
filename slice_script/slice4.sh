#!/bin/sh

echo '---------- Disattivazione Slice 4 ----------'

# Disabilita le porte di s5 che sono collegate a h7 e h8 utilizzando ifconfig
sudo ifconfig s5-eth1 down  # Disabilita la porta collegata a h7
sudo ifconfig s5-eth2 down  # Disabilita la porta collegata a h8

# Blocca il traffico tra s5 e s1 per isolare la slice 4 dal resto della rete
sudo ovs-ofctl add-flow s5 priority=65500,in_port=s5-eth3,actions=drop
sudo ovs-ofctl add-flow s1 priority=65500,in_port=s1-eth4,actions=drop

# Blocca ulteriormente il traffico in entrata/uscita su s5-eth1 e s5-eth2
sudo ovs-ofctl add-flow s5 priority=65535,in_port=s5-eth1,actions=drop
sudo ovs-ofctl add-flow s5 priority=65535,in_port=s5-eth2,actions=drop


echo 'Slice 4 disattivata.'
