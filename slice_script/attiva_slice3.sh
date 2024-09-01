#!/bin/sh

echo '---------- Riattivazione Slice 3 ----------'

# Riattiva le porte di s4 che sono collegate a h5 e h6 utilizzando ifconfig
sudo ifconfig s4-eth1 up  # Riattiva la porta collegata a h5
sudo ifconfig s4-eth2 up  # Riattiva la porta collegata a h6

# Rimuovi le regole di blocco del traffico tra s4 e s1
sudo ovs-ofctl del-flows s4 "in_port=s4-eth3"
sudo ovs-ofctl del-flows s1 "in_port=s1-eth3"

# Rimuovi ulteriori regole di blocco del traffico in entrata/uscita su s4-eth1 e s4-eth2
sudo ovs-ofctl del-flows s4 "in_port=s4-eth1"
sudo ovs-ofctl del-flows s4 "in_port=s4-eth2"

echo 'Slice 3 riattivata.'
